function [log] = load_log(exp,sub,block)

% Function to load relevant data from the log file for each of the blocks

global datapath Connector
log.name=['e',num2str(exp),'v',num2str(sub),'b',num2str(block)]; % File and folder name
file = load([datapath,log.name,Connector,log.name,'.log']); 


%% Save important variables 

log.direction = file(:,9);
log.tx = file(:,11); 
log.xstart = file(:,22); 
log.xend = file(:,24); 
log.xstart2 = file(:,18); 
log.xend2 = file(:,20);

end