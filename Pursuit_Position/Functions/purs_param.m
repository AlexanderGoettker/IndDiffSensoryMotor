function [latency acc vel gain sacc Bad_Trial ] = purs_param(xpos,xvel,xvel_int,events,saccade,TarVel);

global PursCounter VelCounter

Bad_Trial = 0;
vel_sacc = NaN;
%% Get pursuit onset and acceleration
[latency x acc cons_latency cons_x Bad_Trial Bad_Trial_cons] = detect_pursuit_onset(xvel_int, TarVel, events(2), 0);
latency = cons_latency;

%% If you didnt find a pursuit response or the onset was too early or to late, label it
if latency < 50  | latency > 700  | Bad_Trial == 1
    % if latency < 50  | latency > 500  | Bad_Trial == 1
    
    Bad_Trial =1;
    
    PursCounter =PursCounter+1;
end


%% Get steady-state gain

if Bad_Trial == 0
    
    gain = nanmedian(xvel(events(2)+latency+200:events(2)+latency+300))/TarVel;
    vel = nanmedian(xvel(events(2)+latency+200:events(2)+latency+300));
    
    
    if isnan(vel)  | gain < 0.3 | gain > 2
        Bad_Trial =1;
        PursCounter =PursCounter+1;
        
    end
    % Check for saccade
    sacc = 0;
    
    if ~isempty(saccade)
        sacc_latency = saccade(:,1)-events(2);
        
        comb = min(find(sacc_latency > 0 & sacc_latency<= 400));
        if ~isempty(comb)
            sacc = 1;
        end
        
        
    end
else
    gain = NaN;
    sacc = NaN;
    vel= NaN;
end

