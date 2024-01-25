%% Look at gaze
clear all
close all

%% Define Pathway
addpath(genpath('../Psycho_Motion'))
Subject = {'1','2','4','6','7','8','9','10','11','12','13','14','15','16','17','18','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','36','37','38','39','40','41','42','43','45','46','47','48','49','50','51','52','54','55','56'}; % Subjects 
% Subject = {'49'}; % Subjects

Experiment = {'1'};
Block = {'1'}; % Blocks
Number_of_Trials = 150;
Figures = 1;

global datapath stimpath conv resultpath Colormap Connector
if ismac
    datapath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/Data/Psycho_Motion/';
    resultpath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/ResultsClean/Psycho_Motion/';
    Connector ='/';
else
    datapath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\Data\Psycho_Motion\';
    resultpath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\ResultsClean\Psycho_Motion\';
    Connector ='\';

end
%% Setup the conversion from pixels to degree and filters

conv = setup(1920,1080,30,53,90,1000,60);

%% Now loop through the trials
for exp = 1: length(Experiment)
    for subject = 1:length(Subject)
        for block = 1: length(Block)

            disp(['This is Experiment ', Experiment{exp}, ' Subject ', Subject{subject}, ' Block ', Block{block}])

            %% load the respective log file
            log_file = load_log(str2num(Experiment{exp}),str2num(Subject{subject}),str2num(Block{block}));

            sub.dir(exp,subject,block,:) = log_file.dir;
            sub.speed(exp,subject,block,:) = log_file.speed;
            sub.response(exp,subject,block,:) = log_file.rating;

            %% Compute the psychometric curves

            [sub.perceptual_JND(exp,subject) sub.perceptual_PSE(exp,subject) sub.responses(exp,subject,:)] = compute_psycho(log_file.speed,log_file.rating,subject,Figures);
            close all
            %% Now go through the individual trials for eye tracking
            disp('Loop through the Trials...')
            for t = 1:Number_of_Trials
                %% Load and prepare the data
                [xpos_raw ypos_raw events saccade pupil sub.Bad_Trial(exp,subject,block,t)] = load_eye(log_file,t); % Load & Process the eye movement data

                % Align the direction of trials
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

                    %% Compute some  pursuit parameters
                    [sub.Latency(exp,subject,block,t) sub.Acc(exp,subject,block,t) sub.Vel(exp,subject,block,t) sub.Gain(exp,subject,block,t)...
                        sub.Sacc(exp,subject,block,t) sub.Bad_Trial_eye(exp,subject,block,t) sub.VelSacc(exp,subject,block,t)] = purs_param(xpos,xvel,xvel_interp,events,saccade,sub.speed(exp,subject,block,t));
                end

            end

            %% Plot the velocity traces
            [sub.Avg_Gain(exp,subject,:) sub.ReliableGain(exp,subject,:,:)]=plot_vel(sub,subject,Figures);

            %% Now compute the oculometric curves

            bad = length(find(sub.Bad_Trial(exp,subject,:) == 1));
            all = length(sub.Bad_Trial(exp,subject,:));
            disp(['You have found ', num2str(bad/all*100),' % of Bad Trials'])

            Bad_Sub(exp,subject) = bad/all*100;


        end
    end
end

if Figures
    Steps = unique(sub.speed(exp,subject,block,:));
    Values = squeeze(mean(sub.responses(exp,:,:)));
    Std_Values = squeeze(std(sub.responses(exp,:,:)));
    dat(:,1)= Steps;
    dat(:,2) = Values;
    dat(:,3) = ones(length(Steps),1)*length(Subject);

    [xpar mconf sconf xx Values] = pfitb(dat,'plot','shape','gauss' ); % pfitb
    figure;
    hold on;
    errorbar(dat(:,1),dat(:,2),Std_Values,'ko','MarkerFaceColor','k')
    plot(xx,Values,'k-','LineWidth',2)
    xlabel('Step Size')
    ylabel('P(Faster)')
    xlim([7.5 12.5])
    ylim([0 1])

    % Plot the reliability figure

    figure;
    hold on
    plot(mean(squeeze(sub.ReliableGain(exp,:,:,1)),2),mean(squeeze(sub.ReliableGain(exp,:,:,2)),2),'o','Color',[0.5 0.5 0.5])
    plot([0.4 1],[0.4 1],'k-')
    axis square
    [x p] = corrcoef(mean(squeeze(sub.ReliableGain(exp,:,:,1)),2),mean(squeeze(sub.ReliableGain(exp,:,:,2)),2),'Rows','complete');
    xlabel('Gain Odd')
    ylabel('Gain Even')
    title('Correlation is : ', num2str(x(1,2)))

end


%% Save the relevant things

for subject = 1:length(Subject)
    results.JND(str2num(Subject{subject})) = sub.perceptual_JND(1,subject);
    results.PSE(str2num(Subject{subject})) = sub.perceptual_PSE(1,subject);
    results.GainPsycho(str2num(Subject{subject})) = nanmean(sub.Avg_Gain(1,subject,:));
    results.Bad_Trials(str2num(Subject{subject})) = Bad_Sub(1,subject);
end

save([resultpath,'Psycho_Motion'],'results')

%% Valid Trials
all = length(sub.Bad_Trial(:));
bad = length(find(sub.Bad_Trial(:)==1));
disp(['Psycho Motion: You can use ', num2str(all-bad), ' of ', num2str(all), ' trials for the analysis (', num2str((all-bad)/all*100),')'])
bad = length(find(sub.Bad_Trial_eye(:)==1));
disp(['Psycho Motion eye : You can use ', num2str(all-bad), ' of ', num2str(all), ' EYE trials for the analysis (', num2str((all-bad)/all*100),')'])

