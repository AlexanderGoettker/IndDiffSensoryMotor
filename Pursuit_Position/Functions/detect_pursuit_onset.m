function [latency x acc cons_latency cons_x Bad_Trial Bad_Trial_cons] = detect_pursuit_onset(vel, Tar_Speed, Start, debug)

%% Function for pursuit detection
%Criterion:  Speed has to be over a certain has to be over a certain
%threshol from fixation

% Has to be a few samples at a certain proporion of the target speed

% If you have this point fit a linear regression to check for the beginning
% of the pursuit

% Outputs :
% cons_latency & cons_x --> Point were the speed is above
% threshold and stays there for 5 consecutive frames

% Latency & x & acc --> Latency and onset based on additional regression of
% the speed of the target

if debug == 1
    figure(999)
    plot(vel)
    
end;

%% Parameter
Bad_Trial = 0;
Bad_Trial_cons =0;
Sampling_Rate = 1; % the factor you have to mulitply the distance in frames
Window = [-25 25]; % Time Window for baseline pursuit speed
Regress_window = 30; % Size of the window for the regression
Factor = 3; % Number of Sd the speed has to pass
Propotion = 0.3;  % The proportion of target speed it has to overpass
Samples_above_Thres = 50;

% Initialize the variables

latency= 0;
x = 0;
acc= 0;
cons_latency= 0;
cons_x = 0;
%% Calculate the baseline speed

Base_Speed = nanmean(vel(Start+Window(1): Start+Window(2)));
Std_Base_Speed = nanstd(vel(Start+Window(1): Start+Window(2)));


if Tar_Speed < 0
    Thres = Base_Speed-Factor*Std_Base_Speed;
else
    Thres = Base_Speed+Factor*Std_Base_Speed;
end;

%% Now find the first point which is over/under the threshold
Flag = 0;
Begin = Start+25; % Minimum start point 50 ms after the target movement onset

while Flag == 0
    
    % Find the point that is above the threshold
    for aa = Begin: length(vel)
        if Tar_Speed < 0
            if vel(aa) < Thres
                break
            end;
        else
            if vel(aa) > Thres
                break
            end
        end;
    end
    if debug
        figure(999)
        hold on
        plot (aa,vel(aa),'ko')
        
    end;
    
    if aa + Samples_above_Thres > length(vel)
        Bad_Trial = 1 ;
        Flag =1;
    end
    
    if Bad_Trial == 0
        %% Check that from point there are enough samples  over the proportion of target threshold
        Speed_Prop = 0;
        
        for dd = aa+1: aa+Samples_above_Thres
            
            if Tar_Speed < 0
                if vel(dd) < Propotion*Tar_Speed
                    Speed_Prop = Speed_Prop+1;
                end
            else
                if vel(dd) > Propotion*Tar_Speed
                    Speed_Prop = Speed_Prop+1;
                end
            end;
        end
        if Speed_Prop == Samples_above_Thres | Bad_Trial == 1 % If you have those samples
            Flag = 1;  % Exit the loop
        else
            Begin = aa +1;  % Else set the beginning of the next try to one above the one you found
            
            if Begin > length(vel)-10 % If you do not find any valid sample
                Bad_Trial= 1; % assign  a bad Trial
                Flag = 1;  % Exit the loop
            end;
        end
        
    end
end;
if debug
    figure(999)
    hold on
    plot (aa,vel(aa),'bo')
    
end
if aa > length(vel)- Regress_window
    Bad_Trial= 1;
end
Bad_Trial_cons = Bad_Trial ;

if  Bad_Trial == 0 % If you found a valid pursuit onset
    %% Save the conservative latency and onset
    
    cons_x = aa;
    cons_latency = (aa-Start)* Sampling_Rate;
    if cons_latency < 0
        Bad_Trial_cons = 1;
    end
    
    %% Now fit the linear regression to the data
    
    param = polyfit ([aa-Regress_window:aa+Regress_window]',vel(aa-Regress_window:aa+Regress_window),1);
    param_acc = polyfit ([0:Sampling_Rate/1000:((Regress_window*2))*(Sampling_Rate/1000)]',vel(aa-Regress_window:aa+Regress_window),1);
    
    if debug ==1
        figure(999)
        hold on ;
        plot([aa-Regress_window:aa+Regress_window]',param(1)*[aa-Regress_window:aa+Regress_window]'+param(2))
    end
    
    % Find the point where the regression goes to zero
    
    x = -param(2)/param(1) ;
    
    %% Check whether the aa is not on the opposite side of minimum in acceleration and else adjust it
    
    % Look up the accerlation distribution
    
    acceleration = diff(vel)* 1000;
    
    %% Do some control based on speed and acceleration
    % Check wether at the point you determined the acceleration is in the
    % correct direction
    if isnan(x) | x < 0 | x > length(acceleration)% If you have a smaller latency than the starting point you assign  a bad trial
        Bad_Trial =1;
    end
    
    %% Calculate the parameters
    
    latency = (round(x) -Start)*Sampling_Rate;
    acc = param_acc(1);
    
    if debug == 1 & Bad_Trial == 0
        figure(999)
        hold on
        plot(round(x),vel(round(x)),'ro')
        %         keyboard
    end;
end % If you have a bad Trial

if Bad_Trial == 1 % If you have a bad Trial assign NaNs to output
    latency = NaN ;
    acc = NaN;
    x= NaN;
end
if Bad_Trial_cons == 1
    cons_x = NaN;
    cons_latency = NaN;
end;



