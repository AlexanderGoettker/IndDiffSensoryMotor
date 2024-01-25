%% Look at gaze
clear all
close all

%% Define Pathway
addpath(genpath('../Psycho_Position'))
Subject = {'1','2','4','6','7','8','9','10','11','12','13','14','15','16','17','18','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','36','37','38','39','40','41','42','43','45','46','47','48','49','50','51','52','54','55','56'}; % Subjects 

Experiment = {'1'};
Block = {'1'}; % Blocks
Number_of_Trials = 150;
Figures = 1;  % If 1, it will show you the average figure

global datapath stimpath conv resultpath Colormap Connector
if ismac
    datapath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/Data/Psycho_Position/';
    resultpath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/ResultsClean/Psycho_Position/';
    Connector ='/';
else
    datapath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\Data\Psycho_Position\';
    resultpath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\ResultsClean\Psycho_Position\';
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
            sub.step(exp,subject,block,:) = log_file.step;
            sub.response(exp,subject,block,:) = log_file.rating;

            %% Compute the psychometric curves
            [sub.perceptual_JND(exp,subject) sub.perceptual_PSE(exp,subject) sub.responses(exp,subject,:)] = compute_psycho(log_file.step,log_file.rating,subject,Figures);
            close all

            %% Now go through the individual trials for eye tracking
            disp('Loop through the Trials...')

            for t = 1:Number_of_Trials
                %% Load and prepare the data
                [xpos_raw ypos_raw events saccade pupil sub.Bad_Trial(exp,subject,block,t)] = load_eye(log_file,t); % Load & Process the eye movement data
                if sub.dir(exp,subject,block,t) == 180
                    xpos_raw = xpos_raw.*-1;
                end

                [xpos ypos xvel yvel vel sub.Bad_Trial(exp,subject,block,t)] = compute_vel(xpos_raw,ypos_raw, sub.Bad_Trial(exp,subject,block,t));  % Compute the velocity and filter the traces

                [xtar ytar ] = load_target(log_file,events,t);

                % Note: We do not actually analyze the eye tracking data
                % for this experiment ! 

            end
               
                       
        bad = length(find(sub.Bad_Trial(exp,subject,:) == 1));
        all = length(sub.Bad_Trial(exp,subject,:));
        disp(['You have found ', num2str(bad/all*100),' % of Bad Trials'])

            Bad_Sub(exp,subject) =bad/all*100;
                   
        end
    end
end
keyboard
if Figures
Steps = unique(sub.step(exp,subject,block,:)).*10;
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
ylabel('P(Further)')
xlim([1 3])
ylim([0 1])
print([resultpath,'AveragePsycho'],'-dtiff')
end
%% Save the relevant things
for subject = 1:length(Subject)
    results.JND(str2num(Subject{subject})) = sub.perceptual_JND(1,subject);
    results.PSE(str2num(Subject{subject})) = sub.perceptual_PSE(1,subject);
    results.Bad_Trials(str2num(Subject{subject})) = Bad_Sub(1,subject);

end

save([resultpath,'Psycho_Position'],'results')

%% Valid Trials
all = length(sub.Bad_Trial(:));
bad = length(find(sub.Bad_Trial(:)==1));
disp(['Psycho Postion: You can use ', num2str(all-bad), ' of ', num2str(all), ' PSYCHO trials for the analysis (', num2str((all-bad)/all*100),')'])

