function [log] = load_log(exp,sub,block)

% Function to load relevant data from the log file for each of the blocks

global datapath Connector savepath
log.name=['e',num2str(exp),'v',num2str(sub),'b',num2str(block)]; % File and folder name
    file = load([datapath,log.name,Connector,log.name,'.log']); 

%% Save important variables 

log.dir = file(:,9); 
log.frame = file(:,12);
log.speed = file(:,10); 

comb = find(log.dir == 180);
log.frame(comb) = log.frame(comb)*-1; 

save_file = [file(:,[1 2 3 4 9 10]) log.frame];
T = array2table(save_file);
T.Properties.VariableNames = {'Experiment','Subject','Block','Trial','Direction','Target Speed','Frame Location'}; 
writetable(T,[savepath,log.name,Connector,log.name,'.csv'])


end