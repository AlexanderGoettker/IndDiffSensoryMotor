
clear all
close all

%% Define Pathway
addpath(genpath('../SmoothZoneFix'))

%% Set default values for plotting
set (0,'DefaultAxesFontSize',16)
set (0,'DefaultLineMarkerSize',12)
set (0,'DefaultAxesLineWidth',1)
warning off

%% Things you want to analyze
Subject = {'1','2','4','6','7','8','9','10','11','12','13','14','15','16','17','18','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','36','37','38','39','40','41','42','43','45','46','47','48','49','50','51','52','54','55','56'}; % Subjects 
Experiment = {'1'};
Block = {'1','2'}; % Blocks
Number_of_Trials = 140; % Number of Trials per Block
metrics = struct;
sub = struct;
Figures =1;

%% Define basic concepts of the setup
global datapath stimpath conv resultpath Connector
if ismac
    datapath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/Data/SmoothZoneFix/';
    resultpath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/ResultsClean/SmoothZoneFix/';
    Connector = '/';
else
    datapath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\Data\SmoothZoneFix\';
    resultpath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\ResultsClean\SmoothZoneFix\';
    Connector = '\';
    
end

%% Setup conversions and filter
conv = setup(1920,1080,30,53,90,1000,60);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now loop through the data

for exp = 1: length(Experiment)
    for subject = 1:length(Subject)
        for block = 1: length(Block)
            
            disp(['This is Experiment ', Experiment{exp}, ' Subject ', Subject{subject}, ' Block ', Block{block}])
            
            %% load the respective log file
            log_file = load_log(Experiment{exp},Subject{subject},Block{block});
            
            sub.tx(exp,subject,block,:)= log_file.tx;
            
            %% Now go through the individual trials
            disp('Loop through the Trials...')
            for t = 1:Number_of_Trials
                %% Load and prepare the data
                [xpos_raw ypos_raw events saccade pupil sub.Bad_Trial(exp,subject,block,t)] = load_eye(log_file,t); % Load & Process the eye movement data
                
                [xpos ypos xvel yvel vel sub.Bad_Trial(exp,subject,block,t)] = compute_vel(xpos_raw,ypos_raw, sub.Bad_Trial(exp,subject,block,t));  % Compute the velocity and filter the traces
                
                [xtar ytar veltar] = load_target(log_file,events,t); % Load the target trajectory
                
                
                % Align the direction
                if log_file.direction(t) == 180
                    xpos= xpos.*-1;
                    xtar = xtar.*-1;
                    xvel = xvel.*-1;
                    veltar= veltar.*-1;
                end
                
                
                %% Create Figures for the Paper
                
                if strcmp(Subject{subject},'15') & block == 1 &   t == 3 |  strcmp(Subject{subject},'15') & block == 1 & t == 10 |  strcmp(Subject{subject},'15') &block == 1 &  t ==112
                    Vek = [-50:400];
                    Tar = xtar(events(2)+Vek);
                    Eye = xpos(events(2)+Vek);
                    sacc = saccade-events(2);
                    if ~isempty(sacc)
                        sacc = sacc(find(sacc(:,1)> 50 & sacc(:,2) < 399),:);
                    end
                    figure;
                    hold on;
                    plot(Vek,Tar,'k--');
                    plot(Vek,Eye,'k-','LineWidth',2);
                    plot(min(sacc):max(sacc),Eye([min(sacc):max(sacc)]+51),'-','LineWidth',2,'Color',[100 200 41]/255)
                    ylim([-5 5])
                    xlim([-50 400])
                    plot(1000*[sub.tx(exp,subject,block,t) sub.tx(exp,subject,block,t)],[-5 0],'k-')
                    ylabel('Horizontal position [deg]')
                    xlabel('Time from motion onset [ms]')
                    
                    
                end
                
                %% Compute Metrics
                
                [sub.sacc(exp,subject,block,t) sub.TX_calc(exp,subject,block,t) ...
                    sub.PE(exp,subject,block,t) sub.RS(exp,subject,block,t) sub.EXTrig(exp,subject,block,t) ...
                   sub.PETrig(exp,subject,block,t)  sub.RSTrig(exp,subject,block,t)  sub.Latency(exp,subject,block,t) ] = check_sacc(xpos,ypos,xtar,ytar,xvel,veltar,saccade,events);
                
                if t == 0.5*  Number_of_Trials
                    disp('...half way done...')
                end
            end % End of trial
            disp('...done...')
            
        end % End of block
        
        %% Compute averages per subject
        metrics = compute_Average(metrics,sub,exp,subject,Figures,Subject{subject});
        
        bad = length(find(sub.Bad_Trial(exp,subject,:) == 1));
        all = length(sub.Bad_Trial(exp,subject,:));
        disp(['You have found ', num2str(bad/all*100),' % of Bad Trials'])
        Bad_Sub(exp,subject) = bad/all*100;
        
        
    end % End of Sub
    
end % End of Exp


for subject = 1:length(Subject)
    
    % Smooth Zone characteristics
    results.Center_corr(str2num(Subject{subject})) = squeeze(metrics.popt_tx(1,subject,1));
    results.Std_corr(str2num(Subject{subject})) = squeeze(metrics.popt_tx(1,subject,2));
    results.Min_corr(str2num(Subject{subject})) = squeeze(metrics.popt_tx(1,subject,3));
    results.Bad_Trials(str2num(Subject{subject})) =  Bad_Sub(exp,subject);
    results.R2(str2num(Subject{subject})) =  metrics.R2(exp,subject);
    results.RMSE(str2num(Subject{subject})) =  metrics.RMSE(exp,subject);

    % Saccade Behavior
    results.EX_all(str2num(Subject{subject}),:) = squeeze(metrics.EXTrig(1,subject,:,1));
    results.PE_all(str2num(Subject{subject}),:) = squeeze(metrics.PETrig(1,subject,:,1));
    results.RS_all(str2num(Subject{subject}),:) = squeeze(metrics.RSTrig(1,subject,:,1));
    results.Latency(str2num(Subject{subject}),:) = squeeze(metrics.Latency(1,subject,:,1));
    
end



save([resultpath,'SmoothZoneFix'],'results')

%% Valid Trials
all = length(sub.Bad_Trial(:));
bad = length(find(sub.Bad_Trial(:)==1));
disp(['Smooth Fix: You can use ', num2str(all-bad), ' of ', num2str(all), ' trials for the analysis (', num2str((all-bad)/all*100),')'])

