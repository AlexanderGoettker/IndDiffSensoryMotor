%% Look at gaze
clear all
close all

%% Define Pathway
addpath(genpath('../Pursuit_Motion'))
%% Set default values for plotting
set (0,'DefaultAxesFontSize',13)
set (0,'DefaultLineMarkerSize',8)
set (0,'DefaultAxesLineWidth',1.2)
warning off
%% Define Things
Subject = {'1','2','4','6','7','8','9','10','11','12','13','14','15','16','17','18','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','36','37','38','39','40','41','42','43','45','46','47','48','49','50','51','52','54','55','56'}; % Subjects 
Experiment = {'1'};
Block = {'1'}; % Blocks
Number_of_Trials = 120;
metrics = struct;
sub = struct;
ReliabilityFigure = 1;

global datapath stimpath conv resultpath Colormap Connector PursCounter FilterCounter VelCounter
PursCounter = 0;
FilterCounter =0;
VelCounter = 0;

if ismac
    datapath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/Data/Pursuit_Motion/';
    resultpath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/ResultsClean/Pursuit_Motion/';
    Connector = '/';
else
    datapath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\Data\Pursuit_Motion\';
    resultpath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\ResultsClean\Pursuit_Motion\';
    Connector = '/';
    
end

%% Setup the filter and conversions
conv = setup(1920,1080,30,53,90,1000,60);

%% Loop through the trials 
for exp = 1: length(Experiment)
    for subject = 1:length(Subject)
        for block = 1: length(Block)
            
            disp(['This is Experiment ', Experiment{exp}, ' Subject ', Subject{subject}, ' Block ', Block{block}])
            
            %% load the respective log file
            log_file = load_log(str2num(Experiment{exp}),str2num(Subject{subject}),str2num(Block{block}));
            
            sub.dir(exp,subject,block,:) = log_file.dir;
            sub.speed(exp,subject,block,:) = log_file.speed;
            
            %% Now go through the individual trials for eye tracking
            disp('Loop through the Trials...')
            for t = 1:Number_of_Trials
                %% Load and prepare the data
                [xpos_raw ypos_raw events saccade pupil sub.Bad_Trial(exp,subject,block,t)] = load_eye(log_file,t); % Load & Process the eye movement data
               
                % Align the different directions 
                if sub.dir(exp,subject,block,t) == 180
                    xpos_raw = xpos_raw.*-1;
                end
               
                [xpos ypos xvel yvel vel sub.Bad_Trial(exp,subject,block,t)] = compute_vel(xpos_raw,ypos_raw, sub.Bad_Trial(exp,subject,block,t));  % Compute the velocity and filter the traces
                [xtar ytar tarvel] = load_target(log_file,events,t);
                
                
                % Eliminate Saccades from the velocity trace
                xvel_interp = xvel;

                if ~isempty(saccade)
                    for aa = 1: size(saccade,1)
                        if saccade(aa,1) > 31 & saccade(aa,2) < length(xvel)-30
                            xvel(saccade(aa,1)-30:saccade(aa,2)+30) = NaN;
                            xvel_interp(saccade(aa,1)-30:saccade(aa,2)+30) = linspace(xvel_interp(saccade(aa,1)-30),xvel_interp(saccade(aa,2)+30),(saccade(aa,2)+30)-(saccade(aa,1)-30)+1 );

                        end
                    end
                end
                
                
                %% Now compute velocities aligned to target movement onset
                if sub.Bad_Trial(exp,subject,block,t) == 0
                    [sub.VelVek(:,exp,subject,block,t) sub.Timing] = Comp_VelVek(xvel,events);
                    
                    % Now compute some pursuit parameter
                    
                    [sub.Latency(exp,subject,block,t) sub.Acc(exp,subject,block,t) sub.Vel(exp,subject,block,t) sub.Gain(exp,subject,block,t)...
                        sub.Sacc(exp,subject,block,t) sub.Bad_Trial(exp,subject,block,t)] = purs_param(xpos,xvel,xvel_interp,events,saccade,sub.speed(exp,subject,block,t));
                                     
                else
                    FilterCounter = FilterCounter+1;
                end
                
                clear xvel xvel_interp
            end
            
            %% Plot the velocity traces
          
            metrics = compute_Average(metrics,sub,exp,subject);
            
            bad = length(find(sub.Bad_Trial(exp,subject,:) == 1));
            all = length(sub.Bad_Trial(exp,subject,:));
            disp(['You have found ', num2str(bad/all*100),' % of Bad Trials'])
            
            Bad_Sub (exp,subject) = bad/all*100;
            
            
        end
    end
end


%% Visualize things
Color = cbrewer('seq','Blues',6);
Color(find(Color>1))= 1; Color(find(Color<=0))= 0;
Color = Color(4:6,:); 
Speed = unique(sub.speed(exp,subject,:));

for loop_vel = 1:3
    
    figure(999)
    hold on;
    shadedErrorBar(sub.Timing,mean(squeeze(metrics.Vel(:,exp,:,loop_vel)),2),std(squeeze(metrics.Vel(:,exp,:,loop_vel))'),'lineprops',{'-','Color',Color(loop_vel,:)})
    plot(sub.Timing,mean(squeeze(metrics.Vel(:,exp,:,loop_vel)),2),'-','LineWidth',3,'Color',Color(loop_vel,:))
    ylabel('Eye Speed')
    xlabel('Time')
    ylim([-2 16])
    plot([-50 600],[0 0],'k--')
    
end

%% Look at direction differences


figure;
for aa = 1:length(Subject)
hold on;
plot(mean(squeeze(metrics.DIRGain(1,aa,:,1,1))),mean(squeeze(metrics.DIRGain(1,aa,:,2,1))),'o','Color','k','MarkerFaceColor','k')
xlabel('Relative Horizontal Error RIGHT')
ylabel('Relative Vertical Error LEFT')
plot([-1 1],[0 0],'k--')
plot([0 0],[-1 1],'k--')
Vek = mean(squeeze(metrics.DIRGain(1,:,:,1,1)),2); 
check = find(Vek > 0.5); 
[x p] = corrcoef(mean(squeeze(metrics.DIRGain(1,check,:,1,1)),2),mean(squeeze(metrics.DIRGain(1,check,:,2,1)),2));
title(['Correlation is: ',num2str(x(1,2))])
end

Pursuit= metrics.DIRGain;
save('PursuitDirection','Pursuit')

if ReliabilityFigure
figure; 
hold on; 
plot(mean(squeeze(metrics.ReliabilityLatency(exp,:,:,1)),2),mean(squeeze(metrics.ReliabilityLatency(exp,:,:,2)),2),'o','Color',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5])
plot([200 400],[200 400],'k-')
axis square
[x p] = corrcoef(mean(squeeze(metrics.ReliabilityLatency(exp,:,:,1)),2),mean(squeeze(metrics.ReliabilityLatency(exp,:,:,2)),2),'Rows','complete');
title(['Correlation is: ', num2str(x(1,2))])
xlabel('Pursuit Latency Odd')
ylabel('Pursuit Latency Even')

figure; 
hold on; 
plot(mean(squeeze(metrics.ReliabilityGain(exp,:,:,1)),2),mean(squeeze(metrics.ReliabilityGain(exp,:,:,2)),2),'o','Color',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5])
plot([0.6 1.2],[0.6 1.2],'k-')
axis square
[x p] = corrcoef(mean(squeeze(metrics.ReliabilityGain(exp,:,:,1)),2),mean(squeeze(metrics.ReliabilityGain(exp,:,:,2)),2),'Rows','complete');
title(['Correlation is: ', num2str(x(1,2))])
xlabel('Pursuit Latency Odd')
ylabel('Pursuit Latency Even')


figure; 
hold on; 
plot(mean(squeeze(metrics.ReliabilityAcc(exp,:,:,1)),2),mean(squeeze(metrics.ReliabilityAcc(exp,:,:,2)),2),'o','Color',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5])
plot([50 150],[50 150],'k-')
axis square
[x p] = corrcoef(mean(squeeze(metrics.ReliabilityAcc(exp,:,:,1)),2),mean(squeeze(metrics.ReliabilityAcc(exp,:,:,2)),2),'Rows','complete');
title(['Correlation is: ', num2str(x(1,2))])
xlabel('Pursuit Latency Odd')
ylabel('Pursuit Latency Even')

end

%% Save things 
for subject = 1:length(Subject)
       
    if  nanmean(squeeze(metrics.Gain(1,subject,:,1))) <0.5 % Exclude the participant with a very low gain 
        results.Gain(str2num(Subject{subject})) = NaN;
         results.Sacc(str2num(Subject{subject})) = NaN;
        results.Latency(str2num(Subject{subject})) = NaN;
        results.Acc(str2num(Subject{subject})) = NaN;
        results.Bad_Trials(str2num(Subject{subject})) =  Bad_Sub(exp,subject);

       else
        
        results.Gain(str2num(Subject{subject})) = nanmean(squeeze(metrics.Gain(1,subject,:,1)));
        results.Sacc(str2num(Subject{subject})) = nanmean(squeeze(metrics.SaccRate(1,subject,:,1)));
        results.Latency(str2num(Subject{subject})) = nanmean(squeeze(metrics.Latency(1,subject,:,1)));
        results.Acc(str2num(Subject{subject})) = nanmean(squeeze(metrics.Acc(1,subject,:,1)));
          results.Bad_Trials(str2num(Subject{subject})) =  Bad_Sub(exp,subject);
    end
  
end

save([resultpath,'Pursuit_Motion'],'results')

%% Valid Trials
all = length(sub.Bad_Trial(:));
bad = length(find(sub.Bad_Trial(:)==1));
disp(['Smooth Purs: You can use ', num2str(all-bad), ' of ', num2str(all), ' trials for the analysis (', num2str((all-bad)/all*100),')'])

