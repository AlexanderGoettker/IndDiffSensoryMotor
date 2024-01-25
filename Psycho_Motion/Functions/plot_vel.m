function [Avg_Gain ReliableAvg_Gain] = plot_vel(sub,subject,Figure)

global resultpath

%% Get all the velocities
Speeds= unique(sub.speed(1,subject,:));

for loop_v = 1: length(Speeds) % Loop over the velocityies
    
    % Find the good trials and compute average gain
    comb_oculo = find(sub.speed(1,subject,:) == Speeds(loop_v) & sub.Bad_Trial(1,subject,:)==0 & sub.Bad_Trial_eye(1,subject,:)==0);
    Avg_Gain(loop_v)= nanmean(sub.Gain(1,subject,comb_oculo));
    
    %% Compute the reliability
    odd = [1:2:length(comb_oculo)]; even = [2:2:length(comb_oculo)];
        
    ReliableAvg_Gain(loop_v,:)= [nanmean(sub.Gain(1,subject,comb_oculo(odd)))  nanmean(sub.Gain(1,subject,comb_oculo(even)))];
    
end


