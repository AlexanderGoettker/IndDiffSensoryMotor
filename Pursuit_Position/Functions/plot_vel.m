function [ Effect_vel Average  ReliabilityEffect_vel] = plot_vel(sub,subject,Figure)

global resultpath 


%% Get all the velocities 
Frame= unique(sub.frame(1,subject,:)); 
Color = cbrewer('div','Spectral',3); 
hold on;

for loop_v = 1: length(Frame) 
    
    comb = find(sub.frame(1,subject,:) == Frame(loop_v) & sub.Bad_Trial(1,subject,:)==0); 
 
 % Compute the average velocity for each condition   
    Average(loop_v,:) = nanmedian(squeeze(sub.VelVek(:,1,subject,comb)),2);
    Average_pos(loop_v,:) = nanmedian(squeeze(sub.PosVek(:,1,subject,comb)),2);



%% Do a reliability check 
odd = [1:2:length(comb)]; even = [2:2:length(comb)]; 
Average_odd(loop_v,:) = nanmedian(squeeze(sub.VelVek(:,1,subject,comb(odd))),2);
Average_even(loop_v,:) = nanmedian(squeeze(sub.VelVek(:,1,subject,comb(even))),2);



end

%% Compute the difference in eye velocity between cue in front and behind  
% To quantify the effect, compute the difference in this interval -->
% Interval was defined based on visual inspection of average plots 
Interval = find(sub.Timing > 100 & sub.Timing < 180);
Effect_vel = mean(Average(3,Interval)-Average(1,Interval));
ReliabilityEffect_vel= [mean(Average_odd(3,Interval)-Average_odd(1,Interval)) mean(Average_even(3,Interval)-Average_even(1,Interval))]; 


