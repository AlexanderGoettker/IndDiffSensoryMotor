function [JND PSE Avg_Resp] = compute_psycho(step, rating,subject,Figure)
global resultpath

% Find all the different Step Sizes

Step = unique(step);

% Loop through them and compute the prob of further
for loop_v = 1: length(Step)
    comb = find(step==Step(loop_v));
    Avg_Resp(loop_v) = mean(rating(comb));
    Num_Trial(loop_v) = length(comb);
end



%% Prepare fitting

dat(:,1)= Step;
dat(:,2) = Avg_Resp;
dat(:,3) = Num_Trial;

[xpar mconf sconf xx Values] = pfitb(dat,'plot','shape','gauss' ); % pfitb

if Figure % Uncomment this if you are interested in individual Psychometric Curves
%     figure;
%     hold on;
%     plot(dat(:,1),dat(:,2),'ko','MarkerFaceColor','k')
%     plot(xx,Values,'k-','LineWidth',2)
%     xlabel('Target Step ')
%     ylabel('Proportion Further')
%     xlim([0.05 0.35])
%     ylim([0 1])
end
%print([resultpath,'Perceptual PSE ', num2str(subject)],'-dtiff')

PSE = xpar(1);  % First one is the PSE
JND = xpar(2); % Second one is the JND





