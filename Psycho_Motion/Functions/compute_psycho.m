function [JND PSE Avg_Resp] = compute_psycho(speed, rating,subject,Figure)
global resultpath
% Find all the speeds 
Speed = unique(speed); 

% Loop through them and compute the prob of faster
for loop_v = 1: length(Speed); 
    
    comb = find(speed==Speed(loop_v));
    Avg_Resp(loop_v) = mean(rating(comb)); 
    Num_Trial(loop_v) = length(comb);     
end


%% Prepare fitting 

dat(:,1)= Speed; 
dat(:,2) = Avg_Resp; 
dat(:,3) = Num_Trial; 


  [xpar mconf sconf xx Values] = pfitb(dat,'plot','shape','gauss' ); % pfitb

  if Figure
    figure;
    hold on;
    plot(dat(:,1),dat(:,2),'ko','MarkerFaceColor','k')
    plot(xx,Values,'k-','LineWidth',2)
    xlabel('Target Speed [deg/s]')
    ylabel('Proportion Faster Responses')
    xlim([8 12])
    ylim([0 1])
  end
%     print([resultpath,'Perceptual PSE ', num2str(subject)],'-dtiff')
    
PSE = xpar(1);  % First one is the PSE 
JND = xpar(2); % Second one is the JND 





