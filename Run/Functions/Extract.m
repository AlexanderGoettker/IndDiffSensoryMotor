function [] = Extract(savepath)
addpath(genpath('../Master'))
warning off

global Subject_Vek
Subject = Subject_Vek;
Exp = {'Saccade_Position','Saccade_Motion','Psycho_Position','Psycho_Motion','SmoothZoneFix','SmoothZonePurs','Pursuit_Position','Pursuit_Motion'};
%% Load the merged data file
if ismac
    load([savepath,'Merged'])
else
    load([savepath,'\Merged'])
end

%% Structure and bring together the results
% Some dummy variables
sacc = 1;
zone = 1;
psych = 1;

for exp = 1:length(Exp) % Loop through all Experiments

    Bad_Trial{exp} = merge.(Exp{exp}).Bad_Trials(Subject); % Get the excluded trials per observer per experiment

        %% For the saccade tasks
    if strcmp(Exp{exp},'Saccade_Position') | strcmp(Exp{exp},'Saccade_Motion')

        Hor_Error(sacc,:) = merge.(Exp{exp}).HorError(Subject); % Average Horizontal Error
        Ver_Error(sacc,:) = merge.(Exp{exp}).VerError(Subject);  % Vertical Error
        Sacc_Latency(sacc,:) = merge.(Exp{exp}).Latency(Subject); % Saccade Latency
        sacc = sacc+1;  % Update by 1 to enter variables in the second column now

        %% For the psychophysics tasks
    elseif strcmp(Exp{exp},'Psycho_Position')  % for the position task get, the Sensitivity
        JND(psych,:)= 1./merge.(Exp{exp}).JND(Subject); % Sensitivity defined as 1/JND
        psych = psych+1;
    elseif strcmp(Exp{exp},'Psycho_Motion') % for the motion task...
        GainPsycho= merge.(Exp{exp}).GainPsycho(Subject); %% also get the pursuit gain during the psychophysics task
        JND(psych,:)= 1./merge.(Exp{exp}).JND(Subject);  %% Get the sensitivity as 1/JND

        %% For the Smooth Zone/Interaction Experiments
    elseif strcmp(Exp{exp},'SmoothZoneFix') | strcmp(Exp{exp},'SmoothZonePurs')

        % Get the parameter of the zone with corrected EX
        Center_corr(zone,:) = merge.(Exp{exp}).Center_corr(Subject); % Center of the smooth Zone
        Min_corr(zone,:) = merge.(Exp{exp}).Min_corr(Subject); % Min of the smooth Zone
        Std_corr(zone,:) = merge.(Exp{exp}).Std_corr(Subject); % Std of the smooth Zone
        R2(zone,:) = merge.(Exp{exp}).R2(Subject); 
        RMSE(zone,:) = merge.(Exp{exp}).RMSE(Subject);
        EXTrig(zone,:,:) = merge.(Exp{exp}).EX_all(Subject,:);
        PETrig(zone,:,:) = merge.(Exp{exp}).PE_all(Subject,:);
        RSTrig(zone,:,:) = merge.(Exp{exp}).RS_all(Subject,:);
        Latency(zone,:,:) = merge.(Exp{exp}).Latency(Subject,:);

        zone = zone+1; % update by 1

        %% For the Pursuit Motion Experiment
    elseif strcmp(Exp{exp},'Pursuit_Motion')
        Purs_Latency= merge.(Exp{exp}).Latency(Subject); % Get the Latency
        Purs_Acc = merge.(Exp{exp}).Acc(Subject); % Get the acceleration
        Purs_Gain = merge.(Exp{exp}).Gain(Subject); % Get the gain

        %% For the Pursuit Position experiment
    elseif strcmp(Exp{exp},'Pursuit_Position')
        Purs_Effect_vel= merge.(Exp{exp}).Effect_vel(Subject); % Get the difference in the veloicty for the position-influence on pursuit
    end
end

save('Merged Results')