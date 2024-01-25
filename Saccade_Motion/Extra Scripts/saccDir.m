function [weighted_direction Direction_Start Direction_End weighted_slope Slope_b Slope_e ] = saccDir( xdeg, ydeg, vel, time )

% Input X-Position, Y-Position, Eye Speed and Time you want to use for the
% start and End direction


% Outputs --> Saccade Direction for the first xx frames and during the last
% xx frames ; saccade direction weighted on saccade velocity


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% First calculate the direction for the start and End Timing

Begin= [xdeg(1:time) ydeg(1:time)] ;
Ending = [xdeg(end-time:end) ydeg(end-time:end)] ;


Slope_b = (Begin(end,2)- Begin(1,2))/ (Begin(end,1)- Begin(1,1)); % Look up the slope of the beginning
Slope_e = (Ending(end,2)- Ending(1,2))/ (Ending(end,1)- Ending(1,1));  % Look up the slope of the ending


% Now get the angle

Angle_b=  abs(circ_rad2ang(atan(Slope_b)));
Angle_e=  abs(circ_rad2ang(atan(Slope_e)));


% Rotate them so they fit in your coordinate system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for the beginning

if Slope_b < 0 % If the slope is negative
    
    if Begin(end,2) > Begin(1,2) % if P_2 is larger then it is a upward movement
        
        Direction_Start = 180-Angle_b ;
    else
        Direction_Start = 360-Angle_b ;
    end
    
else % If the Slope is positive
    
    if Begin(end,2) > Begin(1,2) % if P_2 is larger then it is a upward movement
        
        Direction_Start = Angle_b ;
    else
        Direction_Start = 180+Angle_b ;
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for the end

if Slope_e < 0 % If the slope is negative
    
    if Ending(end,2) > Ending(1,2) % if P_2 is larger then it is a upward movement
        
        Direction_End = 180-Angle_e;
    else
        Direction_End = 360-Angle_e ;
    end
    
else % If the Slope is positive
    
    if Ending(end,2) > Ending(1,2) % if P_2 is larger then it is a upward movement
        
        Direction_End = Angle_e ;
    else
        Direction_End = 180+Angle_e ;
    end
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now do the weighted thing

% Noramlize the Velocity
norm_vel = vel / max(vel);

for aa = 1: length (norm_vel)-1
    
    Sing_Slope(aa)= (ydeg(aa)-ydeg(aa+1))/ (xdeg(aa)- xdeg(aa+1)); % Look up the slope
    
end

weighted_slope = Sing_Slope*norm_vel(1:end-1)./ sum(norm_vel(1:end-1));
Angle_weight = abs(circ_rad2ang(atan(weighted_slope)));

if weighted_slope < 0 % If the slope is negative
    
    if ydeg(end) > ydeg(1) % if P_2 is larger then it is a upward movement
        weighted_direction = 180-Angle_weight;
    else
        weighted_direction = 360-Angle_weight ;
    end
    
else % If the Slope is positive
    
    if ydeg(end) > ydeg(1) % if P_2 is larger then it is a upward movement
        
        weighted_direction = Angle_weight ;
    else
        weighted_direction = 180+Angle_weight ;
    end
    
end


end

