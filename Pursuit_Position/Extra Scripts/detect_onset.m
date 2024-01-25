%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Function to detect pursuit onset based on the average velocity %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% by Alexander Goettker 

function [Pursuit_latency]= detect_onset(velocity,timepoint) % Input velocity trace, Moment of target step

Window_of_Integration = [200 50]; % Define the borders of the integration window for the standard velocity

Velocity_Average= mean(velocity(timepoint-Window_of_Integration(1):timepoint+Window_of_Integration(2))); % Define the mean velocity between 100 ms before the start during fixation
Std_Average =  std(velocity(timepoint-Window_of_Integration(1):timepoint+Window_of_Integration(2)));

Border_Values= [Velocity_Average+2*Std_Average Velocity_Average-2*Std_Average ]; % Those are the values that the speed has to reach to be considered as the pursuit onset

%% find the direction of motion so that you know which of them you have to choose

Decision= mean(velocity(timepoint+300:timepoint+400));

if Decision >= 0  % If you have a positive movement take the positive threshold
    Threshold = Border_Values(1);
    for tt = timepoint:timepoint+400 % Run through the velocity to see when you crossed the threshold
        if velocity(tt) > Threshold % If you find a value over threshol check whether also the next 10 frames are over threshold to minimize the probability of a local peak 
            if velocity(tt+1)> Threshold & velocity(tt+2)> Threshold & velocity(tt+3)> Threshold & velocity(tt+4)> Threshold &velocity(tt+5)> Threshold & velocity(tt+6)> Threshold & velocity(tt+7)> Threshold & velocity(tt+8)> Threshold & velocity(tt+9)> Threshold & velocity(tt+10)> Threshold  % Check whether the velocity keeps growing
                break
            end
        end
    end
else % Else take the negative one
    Threshold = Border_Values(2);
    for tt = timepoint:timepoint+400
        if velocity(tt) < Threshold
            if velocity(tt+1)< Threshold & velocity(tt+2)< Threshold & velocity(tt+3)< Threshold  & velocity(tt+4)< Threshold & velocity(tt+5)< Threshold  & velocity(tt+6)< Threshold  & velocity(tt+7)< Threshold  & velocity(tt+8)< Threshold  & velocity(tt+9)< Threshold  & velocity(tt+10)< Threshold % Check whether the velocity keeps grwoing
                break
            end
        end
    end
end;

Time_Of_Onset = tt; 

Pursuit_latency = Time_Of_Onset-timepoint; 
if Pursuit_latency > 300 
%     keyboard
end; 
 
% figure; plot ((velocity)); hold on; plot (Time_Of_Onset,velocity(Time_Of_Onset),'ro'); ylim ([-10 10])
% keyboard
end