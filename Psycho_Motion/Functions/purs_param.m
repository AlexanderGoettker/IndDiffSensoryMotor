function [latency acc vel gain sacc Bad_Trial vel_sacc] = purs_param(xpos,xvel,xvel_int,events,saccade,TarVel);

global PursCounter VelCounter

Bad_Trial = 0;
vel_sacc = NaN;
%% Get pursuit onset and acceleration
[latency x acc cons_latency cons_x Bad_Trial Bad_Trial_cons] = detect_pursuit_onset(xvel_int, TarVel, events(2), 0);
latency = cons_latency;

%% If there is no pursuit response or it is too early or too late 
if latency < 50  | latency > 700  | Bad_Trial == 1
    Bad_Trial =1;

    PursCounter =PursCounter+1;
end


%% Get steady-state gain

if Bad_Trial == 0

    if events(2)+latency+300< length(xvel)
        gain = nanmedian(xvel(events(2)+latency+200:events(2)+latency+300))/TarVel;
        vel = nanmedian(xvel(events(2)+latency+200:events(2)+latency+300));
    else
        gain = NaN;
        vel = NaN;

    end

    if  gain < 0.3 | gain > 2
        Bad_Trial =1;
        PursCounter =PursCounter+1;

    end

    %% Check for saccade
    sacc = 0;

    if ~isempty(saccade)
        sacc_latency = saccade(:,1)-events(2);

        comb = min(find(sacc_latency > 0 & sacc_latency<= 400));
        if ~isempty(comb)
            sacc = 1;
        end


        comb = min(find(saccade(:,2)+200 < length(xvel) & saccade(:,1) > events(2)));
        vel_sacc = nanmedian(xvel(saccade(comb,2)+50:saccade(comb,2)+200));
        if vel_sacc < 0.5*TarVel
            vel_sacc = NaN;
        end

    end
else
    gain = NaN;
    sacc = NaN;
    vel= NaN;
end

