function [xtar ytar vel] =load_target(log_file,events,t) 
%%Function to load the correct target trajectory 
global stimpath conv

% target initially in the center
ytar = zeros(events(end),1); 

%% Then moving continously to left or right
xtar(events(2):events(3)) = linspace(log_file.xstart(t)*conv.ppd_x,log_file.xend(t)*conv.ppd_x,(events(3)-events(2))+1);
vel = diff(xtar)*conv.freq_eye;


