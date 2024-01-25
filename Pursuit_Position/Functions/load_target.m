function [xtar ytar vel] =load_target(log_file,events,t) 
%%Function to load the correct target trajectory 
global stimpath conv

% Target starts at 0 
xtar = zeros(events(end),1); 
ytar = zeros(events(end),1); 

% Target moves from events 2 to events 4, events 3 is moment the cue is
% presented
XStart = -log_file.speed(t)*0.2;
XEnd = XStart+(events(4)-events(2))/1000*log_file.speed(t);
xtar(events(2):events(end)) = linspace(XStart,XEnd,(events(end)-events(2))+1);
vel = diff(xtar).*1000;




