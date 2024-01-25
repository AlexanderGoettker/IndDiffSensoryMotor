function [log] = load_log(exp,sub,block)

% Function to load relevant data from the log file for each of the blocks

global datapath Connector
log.name=['e',num2str(exp),'v',num2str(sub),'b',num2str(block)]; % File and folder name
    file = load([datapath,log.name,Connector,log.name,'.log']); 

%% Save important variables 

log.dir = file(:,9); 
log.frame = file(:,12);
log.speed = file(:,10); 

% You need to flip one of the labels here to make it front or back, instead
% of left or right for the position of the cue
comb = find(log.dir == 180);
log.frame(comb) = log.frame(comb)*-1; 

end