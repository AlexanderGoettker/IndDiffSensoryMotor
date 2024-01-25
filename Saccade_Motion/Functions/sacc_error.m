function [error hor_error vert_error latency amplitude Bad_Trial ] = sacc_error(xpos,ypos,xtar,ytar,saccade,events,xvel,yvel)

Bad_Trial = 0;
global SaccCounter TooEarlyCounter

%% Find the saccades that happened at least 50 ms after the target step
comb = min(find(saccade(:,1) > events(2)+50));

% Catch trials where no saccade was detected and a few exceptional trials
% where preprocessing went wrong
if isempty(comb) | events(3)-events(2) < 700 | length(events) == 2
    latency = NaN;
    hor_error = NaN;
    vert_error = NaN;
    error = NaN;
    amplitude = NaN;
    Bad_Trial = 1;
    TooEarlyCounter=TooEarlyCounter+1;
    
else
    
    %% Compute Saccade Parameter
    latency = saccade(comb,1)-events(2); % Latency
    hor_error = xpos(saccade(comb,2))-xtar(saccade(comb,2)); % Horizontal Error
    vert_error = ypos(saccade(comb,2))-ytar(saccade(comb,2)); % Vertical Error
    error = sqrt(hor_error.^2+vert_error.^2); % 2D Error
    amplitude = xpos(saccade(comb,2))-xpos(saccade(comb,1)); % Horizontal Saccade Amplitude
    
    if latency < 50 | latency > 700 | error > 5 % If the latency is too low or too high or the error to big, --> Set it to a BadTrial
        %     if latency < 50 | latency > 500 | error > 5 % If the latency is too low or too high or the error to big, --> Set it to a BadTrial
        
        Bad_Trial = 1;
        SaccCounter = SaccCounter+1;
    end
end

