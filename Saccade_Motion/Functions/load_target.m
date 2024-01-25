function [xtar ytar vel] =load_target(log_file,events,t) 
%%Function to load the correct target trajectory 
global stimpath conv

xtar = zeros(events(end),1); 
ytar = zeros(events(end),1); 
ytar(1:events(2)-1) = -10; 

xtar(events(2):events(end)) = linspace(0,(events(end)-events(2))/1000*log_file.speed(t),(events(end)-events(2))+1);
vel = diff(xtar).*1000;




