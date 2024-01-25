function [sacc TX  PosError VelError EX_SaccTrig PESaccTrig RSSaccTrig sacclat ] = check_sacc(xpos,ypos,xtar,ytar,vel,veltar,saccade, events);

sacc = 0;

%% Find a saccade within the defined window (400 ms after the second target step)
if ~isempty(saccade)
    sacc_latency = saccade(:,1)-events(3);
    
    comb = find(sacc_latency > 0 & sacc_latency<= 400);
    if ~isempty(comb)
        sacc = 1;
    end
    
end

%% Compute the position error an Velocity error at that point for the corrected TX

PosError  = xpos(events(3))-xtar(events(3)); 
VelError = mean(vel(events(3)-75:events(3)+25))-veltar(events(3));

TX =  (-PosError/VelError)*1000;

%% Compute the signal that was used by observers to trigger the corrective saccades
% based on de Brouwer et al. 2002


% Compute position and velocity error during the first 400 ms
PE = xpos(events(3):events(3)+400)-xtar(events(3):events(3)+400);
RS = vel(events(3):events(3)+400)-veltar(events(3):events(3)+400);
ECrossIng= -PE./RS ; % Eye crossing time defined as the ratio of position error and retinal slip
ECrossIng= ECrossIng*-1 ;

% Initialize
EX_SaccTrig = NaN;
PESaccTrig = NaN;
RSSaccTrig = NaN;
sacclat = NaN;

% Look into behavior
if sacc == 1
    if sacc_latency(min(comb))-125 > 1
        
        EX_SaccTrig = ECrossIng(sacc_latency(min(comb))-125); % Get the eye crossing time
        PESaccTrig = PE(sacc_latency(min(comb))-125); % Position error at moment of assumed saccade trigger
        RSSaccTrig = RS(sacc_latency(min(comb))-125); % Velocity error at moment of assumed saccade trigger
        sacclat = sacc_latency(min(comb)); % Take only the first saccade
    end
    
end







