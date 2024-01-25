function [] = load_eye(log_file,t); 
% Function to load the raw eye data and convert them into deg 

global datapath conv Connector savepath % Get the global data 
Bad_Trial = 0; 
%% Load the respective trial

file = load([datapath,log_file.name,Connector,'Trial',num2str(t)]);

save_file = file.trial;
T = array2table(save_file);

T.Properties.VariableNames = {'Time','X-Position Left Eye','Y-Position Left Eye','Events in the trial','X-Position Rigth Eye','Y-Position Rigth Eye','Saccades','Pupilsize','Blinks'}; 
writetable(T,[savepath,log_file.name,Connector,'Trial',num2str(t),'.csv'])



