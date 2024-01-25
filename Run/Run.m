%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Main Script to run the whole analysis at once %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cody by Alexander Goettker Jan 2024

% Define some global variables 
clear all; close all; 
global Subject Subject_Vek

addpath(genpath('./')) %% add the functions folder

%% Specifiy what to analyse 
% Name of the different experiments 
Exp = {'Saccade_Position','Saccade_Motion','Psycho_Position','Psycho_Motion','SmoothZoneFix','SmoothZonePurs','Pursuit_Position','Pursuit_Motion'}; 


% Define Subjects you want to analyze once as a string, once as number
Subject = {'1','2','4','6','7','8','9','10','11','12','13','14','15','16','17','18','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','36','37','38','39','40','41','42','43','45','46','47','48','49','50','51','52','54','55','56'}; % Subjects 
Subject_Vek = [1,2,4,6,7,8,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,36,37,38,39,40,41,42,43,45,46,47,48,49,50,51,52,54,55,56]; % Subjects 

% Define the datapath
if ismac
    Path = '/Users/alexandergottker/Dropbox/IndiDiffStudy/AnalysisClean/'; 
else
    Path= 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\AnalysisClean\';
end

%% Loop to run through the inidividual experiments
tic % Take the time 
for aa = 1:length(Exp) % loop through the experiments 
   disp(['THIS  IS EXPERIMENT: ', Exp{aa}])
   cd([Path,Exp{aa}]) % Go the folder of the respective experiment
    MainFunction; % Execute the main Function --> This will run the analysis and save the results 
end

cd([Path,'Run']) % Go back to the main folder

if ismac
    resultpath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/ResultsClean/';
    Connector = '/';
    savepath = '/Users/alexandergottker/Dropbox/IndiDiffStudy/ResultsClean/Merged/';
else
    resultpath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\ResultsClean\';
    Connector = '\';
    savepath = 'C:\Users\Alexander Goettker\Dropbox\IndiDiffStudy\ResultsClean\Merged\';
end

Merge(resultpath,Connector,savepath); %% Function that merges the result files from individual experiments to a bigger results file
Extract(savepath); %% Function that extracts the relevant variables; 
toc % Take the time 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create figures and analyses in the manuscript 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Please note that Figures 1 & 8 dont include data and were created in a
% graphics programme

%% Figure 2
% The summary figures in the manuscript are produced during the 
% main functions of the respective experiments 

%% Figure 3
Figure3([Path,'Run',Connector]) % Script to produce the panels of Figure 3

%% Figure 4 
Figure4([Path,'Run',Connector]) % Script to produce the panels of Figure 4

%% PCA Table 
StructureDataPCA([Path,'Run',Connector]) % Please note here that the PCA was computed with JASP, this script only saves the matrix used for that

%% Figure 5
% Single Trials and and smooth zones are computed in the respective
% analysis functions 
Figure5([Path,'Run',Connector]) % This script recreates the comparison of the center of the zones between fixation and pursuit
        % as well as the statistcis for the comparison of the different
        % parameters

%% Figure 6
Figure6([Path,'Run',Connector]) % Script to produce panels from Figure 6

%% Exploratory analysis into the saccade trigger for smooth zone 
Figure7([Path,'Run',Connector])
