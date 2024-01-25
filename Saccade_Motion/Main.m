
clear all
close all

%% Define Pathway
addpath(genpath('../Saccade_Motion'))

%% Set default values for plotting
set (0,'DefaultAxesFontSize',13)
set (0,'DefaultLineMarkerSize',8)
set (0,'DefaultAxesLineWidth',1.2)
warning off

%% Things you want to analyze
Subject = {'1','2','4','6','7','8','9','10','11','12','13','14','15','16','17','18','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','36','37','38','39','40','41','42','43','45','46','47','48','49','50','51','52','54','55','56'}; % Subjects 

Experiment = {'1'};
Block = {'1'}; % Blocks
Number_of_Trials = 120; % Number of Trials per Block
metrics = struct;
sub = struct;

ReliabilityFigures = 1; % If Reliability Figures is turned on, also the reliability of the individual measurements will be computed 

%% Define basic concepts of the setup
global datapath stimpath conv resultpath Connector FilterCounter SaccCounter TooEarlyCounter
FilterCounter = 0;
SaccCounter = 0;
TooEarlyCounter = 0;
Counter_Bad_Sub = 0; 
if ismac
    datapath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/Data/Saccade_Motion/';
    resultpath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/ResultsClean/Saccade_Motion/';
    Connector = '/';
else
    datapath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\Data\Saccade_Motion\';
    resultpath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\ResultsClean\Saccade_Motion\';
    Connector = '\';
end

%% Setup the conversion from pixels to degree and filters
conv = setup(1920,1080,30,53,90,1000,60);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now loop through the data

for exp = 1: length(Experiment)
    for subject = 1:length(Subject)
        for block = 1: length(Block)

            disp(['This is Experiment ', Experiment{exp}, ' Subject ', Subject{subject}, ' Block ', Block{block}])

            %% load the respective log file
            log_file = load_log(Experiment{exp},Subject{subject},Block{block});

            sub.direction(exp,subject,block,:)= log_file.direction;
            sub.speed(exp,subject,block,:)= log_file.speed;

            %% Now go through the individual trials
            disp('Loop through the Trials...')
            for t = 1:Number_of_Trials
                %% Load and prepare the data
                [xpos_raw ypos_raw events saccade pupil sub.Bad_Trial(exp,subject,block,t)] = load_eye(log_file,t); % Load & Process the eye movement data

                [xpos ypos xvel yvel vel sub.Bad_Trial(exp,subject,block,t)] = compute_vel(xpos_raw,ypos_raw, sub.Bad_Trial(exp,subject,block,t));  % Compute the velocity and filter the traces

                [xtar ytar veltar] = load_target(log_file,events,t); % Load the target trajectory


                % Align the the directions
                if log_file.direction(t) == 180
                    xpos= xpos.*-1;
                    xvel= xvel.*-1;
                end


                %% Compute Metrics
                if sub.Bad_Trial(exp,subject,block,t) == 0
                       [sub.sacc_error(exp,subject,block,t) sub.hor_error(exp,subject,block,t) sub.vert_error(exp,subject,block,t)...
                        sub.sacc_latency(exp,subject,block,t) sub.amplitude(exp,subject,block,t) sub.Bad_Trial(exp,subject,block,t)]...
                     = sacc_error(xpos,ypos,xtar,ytar,saccade,events,xvel,yvel);
             else
                    FilterCounter = FilterCounter+1;
                end

                if t == 0.5*  Number_of_Trials
                    disp('...half way done...')
                end
            end % End of trial
            disp('...done...')

        end % End of block

        %% Compute averages per subject
        metrics = compute_Average(metrics,sub,exp,subject);

        bad = length(find(sub.Bad_Trial(exp,subject,:) == 1));
        all = length(sub.Bad_Trial(exp,subject,:));
        disp(['You have found ', num2str(bad/all*100),' % of Bad Trials'])

        Bad_Sub(exp,subject) = bad/all*100;
      

    end % End of Sub

end % End of Exp


%% Visualize things
set (0,'DefaultAxesFontSize',16)
set (0,'DefaultLineMarkerSize',12)
set (0,'DefaultAxesLineWidth',1)
warning off

Color = cbrewer('seq','Greys',length(Subject)); % Colormap
Color(find(Color>1))= 1; Color(find(Color<=0))= 0;
load('PlotVektor')

figure;
for aa = 1:length(Subject)
hold on;
plot(mean(squeeze(metrics.HorError(1,aa,:,1))),mean(squeeze(metrics.VerError(1,aa,:,1))),'o','Color','k','MarkerFaceColor',Color(PlotVektor(aa),:))
xlabel('Relative Horizontal Error')
ylabel('Relative Vertical Error')
xlim([-2 1])
ylim([-3 1])
end
plot(0,0,'rs','MarkerFaceColor','r','Markersize',12)

%% Look at Direction Effects 

figure;
for aa = 1:length(Subject)
hold on;
plot(mean(squeeze(metrics.DIRHorError(1,aa,1,:,1))),mean(squeeze(metrics.DIRHorError(1,aa,2,:,1))),'o','Color','k','MarkerFaceColor',Color(PlotVektor(aa),:))
xlabel('Relative Horizontal Error RIGHT')
ylabel('Relative Vertical Error LEFT')
plot([-1 1],[0 0],'k--')
plot([0 0],[-1 1],'k--')
[x p] = corrcoef(mean(squeeze(metrics.DIRHorError(1,:,1,:,1)),2),mean(squeeze(metrics.DIRHorError(1,:,2,:,1)),2));
title(['Correlation is: ',num2str(x(1,2))])
end


SaccMot= metrics.DIRHorError;
save('SaccMotion','SaccMot')
keyboard
%% Reliability

if ReliabilityFigures
figure; 
subplot(1,3,1)
hold on; 
plot(mean(squeeze(metrics.ReliableHorError(exp,:,:,1)),2),mean(squeeze(metrics.ReliableHorError(exp,:,:,2)),2),'o','Color',Color)
axis square
[x p] = corrcoef(mean(squeeze(metrics.ReliableHorError(exp,:,:,1)),2),mean(squeeze(metrics.ReliableHorError(exp,:,:,2)),2));
title(['Correlation is: ', num2str(round(x(1,2),2))])
xlabel('Hor Error Odd'); ylabel('Hor Error Even')
keyboard
subplot(1,3,2)
hold on; 
plot(mean(squeeze(metrics.ReliableVerError(exp,:,:,1)),2),mean(squeeze(metrics.ReliableVerError(exp,:,:,2)),2),'o','Color',Color)
axis square
[x p] = corrcoef(mean(squeeze(metrics.ReliableVerError(exp,:,:,1)),2),mean(squeeze(metrics.ReliableVerError(exp,:,:,2)),2));
title(['Correlation is: ', num2str(round(x(1,2),2))])
xlabel('Vert Error Odd'); ylabel('Vert Error Even')

subplot(1,3,3)
hold on; 
plot(mean(squeeze(metrics.ReliableLatency(exp,:,:,1)),2),mean(squeeze(metrics.ReliableLatency(exp,:,:,2)),2),'o','Color',Color)
axis square
[x p] = corrcoef(mean(squeeze(metrics.ReliableLatency(exp,:,:,1)),2),mean(squeeze(metrics.ReliableLatency(exp,:,:,2)),2));
title(['Correlation is: ', num2str(round(x(1,2),2))])
xlabel('Latency Odd'); ylabel('Latency Even')
end

%% Save Things 
for subject = 1: length(Subject)

     % Collect metrics
      % Collect metrics
    results.HorError(str2num(Subject{subject})) = nanmean(squeeze(metrics.HorError(1,subject,:,1)));
    results.HorError_all(str2num(Subject{subject}),:) = squeeze(metrics.HorError(1,subject,:,1));
    results.Amplitude(str2num(Subject{subject})) = nanmean(squeeze(metrics.Amplitude(1,subject,:,1)));
    results.Amplitude_all(str2num(Subject{subject}),:) = squeeze(metrics.Amplitude(1,subject,:,1));
    results.Error(str2num(Subject{subject})) = nanmean(squeeze(metrics.Error(1,subject,:,1)));
    results.Latency(str2num(Subject{subject})) = nanmean(squeeze(metrics.Latency(1,subject,:,1)));
    results.Latency_all(str2num(Subject{subject}),:) = squeeze(metrics.Latency(1,subject,:,1));
    results.VerError(str2num(Subject{subject})) = nanmean(squeeze(metrics.VerError(1,subject,:,1)));
    results.VerError_all(str2num(Subject{subject}),:) = squeeze(metrics.VerError(1,subject,:,1));
    results.Bad_Trials(str2num(Subject{subject})) =  Bad_Sub(exp,subject);

end


save([resultpath,'Saccade_Motion'],'results')

%% Valid Trials
all = length(sub.Bad_Trial(:));
bad = length(find(sub.Bad_Trial(:)==1));
disp(['Saccade Motion: You can use ', num2str(all-bad), ' of ', num2str(all), ' trials for the analysis (', num2str((all-bad)/all*100),')'])

keyboard
