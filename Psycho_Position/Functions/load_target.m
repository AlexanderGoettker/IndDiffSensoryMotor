function [xtar ytar ] =load_target(log_file,events,t) 
%%Function to load the correct target trajectory 
global stimpath conv

% Target starts in the center
xtar = zeros(events(end),1); 
ytar = zeros(events(end),1); 

xtar(events(2):end) = log_file.step(t)*10; % Position of the target after the step






