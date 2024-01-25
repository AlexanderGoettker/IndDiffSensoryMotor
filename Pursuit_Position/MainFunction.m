function [] = MainFunction(Subject)

%% Look at gaze
global Subject

%% Define Pathway
addpath(genpath('../Pursuit_Position'))

%% Set default values for plotting
set (0,'DefaultAxesFontSize',13)
set (0,'DefaultLineMarkerSize',8)
set (0,'DefaultAxesLineWidth',1.2)
warning off
%% Define stuff
Experiment = {'1'};
Block = {'1','2'}; % Blocks

Number_of_Trials = 120;
metrics = struct;
Figures =0;

global datapath stimpath conv resultpath Colormap Connector

if ismac
    datapath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/Data/Pursuit_Position/';
    resultpath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/ResultsClean/Pursuit_Position/';
    Connector = '/';
else
    datapath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\Data\Pursuit_Position\';
    resultpath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\ResultsClean\Pursuit_Position\';
    Connector = '/';
    
end
Colormap =  cbrewer('div','Spectral',5);

%% Setup filters and conversions
conv = setup(1920,1080,30,53,90,1000,60);

%% Loop through the the trials
for exp = 1: length(Experiment)
    for subject = 1:length(Subject)
        for block = 1: length(Block)
            
            disp(['This is Experiment ', Experiment{exp}, ' Subject ', Subject{subject}, ' Block ', Block{block}])
            
            %% load the respective log file
            log_file = load_log(str2num(Experiment{exp}),str2num(Subject{subject}),str2num(Block{block}));
            
            sub.dir(exp,subject,block,:) = log_file.dir;
            sub.frame(exp,subject,block,:) = log_file.frame;
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
                
                [sub.PosVek(:,exp,subject,block,t) sub.VelVek(:,exp,subject,block,t) sub.Timing sub.Bad_Trial(exp,subject,block,t)] = Comp_VelVek(xpos,xvel,events,sub.Bad_Trial(exp,subject,block,t));
                
                %% Compute basic pursuit parameter
                [sub.Latency(exp,subject,block,t) sub.Acc(exp,subject,block,t) sub.Vel(exp,subject,block,t) sub.Gain(exp,subject,block,t)...
                    sub.Sacc(exp,subject,block,t) sub.Bad_Trial(exp,subject,block,t) ] = purs_param(xpos,xvel,xvel_interp,events,saccade,sub.speed(exp,subject,block,t));
                %
            end % End of Trials
        end % End of Blocks
        
        %% Plot the velocity traces
        
        [ metrics.Effect_vel(subject) metrics.Vel(subject,:,:) metrics.ReliabilityVel(subject,:)]=plot_vel(sub,subject,Figures);
        
        bad = length(find(sub.Bad_Trial(exp,subject,:) == 1));
        all = length(sub.Bad_Trial(exp,subject,:));
        disp(['You have found ', num2str(bad/all*100),' % of Bad Trials'])
        Bad_Sub(exp,subject) = bad/all*100;
        
    end
end


Color_con = [0 1 0; 0 0 0; 0 0 1];
Color = cbrewer('qual','Set2',3);
Color(2,:) = [0.5 0.5 0.5]; 
Color(find(Color>1))= 1; Color(find(Color<=0))= 0;

for loop_c = 1:3
    
    figure(99);
    hold on;
    shadedErrorBar(sub.Timing,mean(metrics.Vel(:,loop_c,:)),std(metrics.Vel(:,loop_c,:))./sqrt(length(Subject)),'lineprops',{'-','Color',Color(loop_c,:)})
    plot(sub.Timing,squeeze(mean(metrics.Vel(:,loop_c,:))),'-','LineWidth',3,'Color',Color(loop_c,:))
    xlim([0 200])
    xlabel('Time relative to Position Cue')
    ylabel('Eye Velocity')
    
    
end

if Figures
    figure;
    hold on;
    plot(metrics.ReliabilityVel(:,1),metrics.ReliabilityVel(:,2),'o','Color',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5])
    plot([-1 2.5],[-1 2.5],'k-')
    axis square
    [x p]= corrcoef(metrics.ReliabilityVel(:,1),metrics.ReliabilityVel(:,2));
    title('Correlation is: ', num2str(x(1,2)))
    xlabel('Pursuit Position Influence Odd')
    ylabel('Pursuit Position Influence Evend')
end

%% Save things
for subject = 1: length(Subject)
    
    % Save Values
    results.Effect_vel(str2num(Subject{subject})) = metrics.Effect_vel(subject);
    results.Bad_Trials(str2num(Subject{subject})) =  Bad_Sub(exp,subject);
end


save([resultpath,'Pursuit_Position'],'results')

%% Valid Trials
all = length(sub.Bad_Trial(:));
bad = length(find(sub.Bad_Trial(:)==1));
disp(['Pursuit Position: You can use ', num2str(all-bad), ' of ', num2str(all), ' trials for the analysis (', num2str((all-bad)/all*100),')'])
