function [xtar ytar vel] =load_target(log_file,events,t) 
%%Function to load the correct target trajectory 
global stimpath conv

ytar = zeros(events(end),1); 
Start=log_file.xstart(t)*conv.ppd_x;
End=log_file.xend(t)*conv.ppd_x;
Start2=log_file.xstart2(t)*conv.ppd_x;
End2=log_file.xend2(t)*conv.ppd_x;

if Start > 0 
    xtar = ones(events(end),1)*15; 
else
        xtar = ones(events(end),1)*-15; 
end

xtar(events(2):events(3)) = linspace(Start,End,(events(3)-events(2))+1);
xtar(events(3):events(4)) = linspace(Start2,End2,(events(4)-events(3))+1);

vel = diff(xtar)*conv.freq_eye;


