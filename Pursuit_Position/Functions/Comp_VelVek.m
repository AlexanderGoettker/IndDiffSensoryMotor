function [Pos_Vek Vel_Vek Timing Bad_Trial] = Comp_VelVek(xpos,vel,events,Bad_Trial); 

%% Get position and velocity aligned on the moment the cue was presented 
Timing = [-200:400];

Pos_Vek = xpos(events(3)-200:events(3)+400);
Vel_Vek = vel(events(3)-200:events(3)+400);
