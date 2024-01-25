function [xpos ypos xvel yvel vel Bad_Trial] = compute_vel(xpos_raw, ypos_raw, Bad_Trial)
% Function to filter eye data and compute velocity

global conv
%% Filter the position traces


xpos = filtfilt(conv.posfil_a,conv.posfil_b,xpos_raw); % Filter X-Position
ypos = filtfilt(conv.posfil_a,conv.posfil_b,ypos_raw); % Filter X-Position

if isnan(xpos(1)) 
    Bad_Trial = 1; 
end 
%% Compute velocity

xvel = diff(xpos).*conv.freq_eye;
yvel = diff(ypos).*conv.freq_eye;
vel =sqrt(xvel.^2 + yvel.^2);

%% Filter the velocity

xvel = filtfilt(conv.velfil_c,conv.velfil_d,xvel); % Filter X-Velocity
yvel = filtfilt(conv.velfil_c,conv.velfil_d,yvel); % Filter Y-Velocity
vel = filtfilt(conv.velfil_c,conv.velfil_d,vel); % Filter overall Velocity



