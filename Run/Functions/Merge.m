function [] = Merge(resultpath, Connector,savepath); 
%% Combine Data and analyze the merged things 

addpath(genpath('../Master'))

% Get the Subjects from the master file
global Subject

% Experiments you want to analye
Exp = {'Saccade_Position','Saccade_Motion','Psycho_Position','Psycho_Motion','SmoothZoneFix','SmoothZonePurs','Pursuit_Position','Pursuit_Motion'}; 

 
for exp = 1: length(Exp)  % Loop through the experiments and put them in one structure
        
    load([resultpath,Exp{exp},Connector,Exp{exp}])
    
    merge.(Exp{exp}) = results; 
        
end

save([savepath,'Merged'],'merge')