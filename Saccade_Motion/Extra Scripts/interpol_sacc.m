%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Function to interpolate the velocity of saccades during pursuit %%%%%%
% Uses linear Interpolation between the endpoints of the saccades and
% weights it with the actual trace
% Function by Alexander Goettker 

function [velocity_interpol Error] = interpol_sacc(velocity,events, linear)

v_saccade = velocity; % Velocity trace with saccades
saccades =  find (bitget(events,1)==1);  % Find momemnts of saccade
Error= 0;
if isempty(saccades) % If you dont have any saccades in the trace just keep it
    velocity_interpol = v_saccade ;
else  % if you have some look at them individually
    
    % Define start and end point of Saccades
    
    
    Multiple= find(diff(saccades)>2);
    
    if length(Multiple)== 0
        Start_Sacc= min(saccades);
        End_Sacc= (max(saccades));
    else
        Start_Sacc= [min(saccades)];
        for bb = 2:length(Multiple)+1
            Start_Sacc(bb)= saccades(Multiple(bb-1)+1);
        end;
        for cc = 1:length(Multiple)
            End_Sacc(cc)= saccades(Multiple(cc));
        end;
        End_Sacc(end+1)= max(saccades);
    end
    
    % Now not use the start and the End of the saccade, but 30 ms more in
    % each direction
    
    Start_Sacc = Start_Sacc-30;
    End_Sacc = End_Sacc+30;
    
    if min(Start_Sacc) <= 0
        Error =  1 ;
    end ;
    
    %% Now that you have the start and endpoints interpolate the velocity for each saccade
    
    if Error == 0 % If you find an error 
        for aa = 1:length(Start_Sacc)
            % Start and end point of respective saccade
            min_Sacc = Start_Sacc(aa);
            max_Sacc= End_Sacc(aa);
            % Velocity at those timepoints
            velocity_min= v_saccade(min_Sacc);
            if max_Sacc > length(v_saccade) % If you have a really late saccade just set it to the last point, you are not really interested in this one anyway
                max_Sacc = length(v_saccade);
            end;
            velocity_max= v_saccade(max_Sacc);
            
            % Linear interpolation
            linear_traj = linspace(velocity_min,velocity_max,max_Sacc-min_Sacc+1);
            vel_traj = v_saccade(min_Sacc:max_Sacc);
            
            % Determine the weights for the trajectories
            weights_trace= zeros(length(linear_traj),1);
            for zz = 1: round(length(linear_traj)/2 ) % weighting of trace with hyperbolic funcion
                weights_trace(zz)= 1/zz;
                weights_trace(end-zz+1)= weights_trace(zz);
            end;
            
            if linear == 1 
                weights_trace= zeros(length(linear_traj),1);
                weights_linear= 1-weights_trace;
            end; 
            % Do the weighting
            for zz= 1:length(linear_traj)
                pol_traj(zz)= [linear_traj(zz)*weights_linear(zz) + vel_traj(zz)*weights_trace(zz)];
            end;
            
            v_saccade(min_Sacc:max_Sacc)= pol_traj;  % Modify the actual trace
            
            clear pol_traj
        end;
        
        
    end;
end;
% When done with the interpolation assign the new velocity trace to the
% output variable
velocity_interpol = v_saccade;  %

end