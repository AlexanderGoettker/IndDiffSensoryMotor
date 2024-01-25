function [] = Figure5(savepath)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Script to create results for Figure 5 %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Load the merged Results file
load([savepath,'Merged Results'])


%% Select Subjects
RepSubj=13; %% This is Subject Number 15, where the example smooth zones are shown
ValidSub = find(Center_corr(1,:) <= 399 & Center_corr(2,:) <= 399); % Select subjects that have a fitted zone that is within the measured range

%% Set default values for plotting
set (0,'DefaultAxesFontSize',16)
set (0,'DefaultLineMarkerSize',12)
set (0,'DefaultAxesLineWidth',1)
warning off

Sacc_Vel = Hor_Error(2,:);

[a idx] = sort(Sacc_Vel); % Get the indexes for plotting
Color = cbrewer('seq','Greys',length(Subject)); % Colormap
Color(find(Color>1))= 1; Color(find(Color<=0))= 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create the figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for sub = 1:length(Subject)
    if ismember(sub,ValidSub)
        
        % Get the correct color for this subject
        col = find(idx == sub);
        
        figure(20);
        hold on;
        plot(Center_corr(1,sub),Center_corr(2,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        plot(Center_corr(1,RepSubj),Center_corr(2,RepSubj),'o','Color','r','MarkerFaceColor','r')
        if sub == length(Subject)
            [x p] = corrcoef(Center_corr(1,ValidSub),Center_corr(2,ValidSub));
            title(['Smooth Center: Correlation is ',num2str(x(1,2)), ', p = ', num2str(p(1,2))])
            param = polyfit(Center_corr(1,:),Center_corr(2,:),1);
            plot([100 400],[100 400]*param(1)+param(2),'k-','LineWidth',2)
            xlim([100 400])
            ylim([100 400])
            plot([100 400],[100 400],'k--','LineWidth',2)
            axis square
            xlabel('Fixation')
            ylabel('Pursuit')
        end
    end
end

%% Comparison of the smooth zone parameter

ColorBar =  [1 0 0; 0 0 1]';

figure(1000)
subplot(1,3,1)
hold on;
bar(1,mean(Center_corr(1,ValidSub)),'EdgeColor',ColorBar(:,1),'FaceColor',[1 1 1],'LineWidth',2)
errorbar(1,mean(Center_corr(1,ValidSub)),std(Center_corr(1,ValidSub)),'Color','k','LineWidth',2)
bar(3,mean(Center_corr(2,ValidSub)),'EdgeColor',ColorBar(:,2),'FaceColor',[1 1 1],'LineWidth',2)
errorbar(3,mean(Center_corr(2,ValidSub)),std(Center_corr(2,:)),'Color','k','LineWidth',2)
plot([1.2 2.8],[Center_corr(1,ValidSub); Center_corr(2,ValidSub)],'-','Color',[0.7 0.7 0.7],'LineWidth',0.5)
plot([1.2 2.8],[Center_corr(1,RepSubj); Center_corr(2,RepSubj)],'-','Color',[0 0 0],'LineWidth',0.5)
set(gca,'XTick',[])
ylabel('Center')
ylim([100 400])
[h p t stats] = ttest(Center_corr(1,ValidSub),Center_corr(2,ValidSub));
title(['t =',num2str(round(stats.tstat,2)),',p =',num2str(p)])

figure(1000)
subplot(1,3,2)
hold on;
bar(1,mean(Min_corr(1,ValidSub)),'EdgeColor',ColorBar(:,1),'FaceColor',[1 1 1],'LineWidth',2)
errorbar(1,mean(Min_corr(1,ValidSub)),std(Min_corr(1,ValidSub)),'Color','k','LineWidth',2)
bar(3,mean(Min_corr(2,ValidSub)),'EdgeColor',ColorBar(:,2),'FaceColor',[1 1 1],'LineWidth',2)
errorbar(3,mean(Min_corr(2,ValidSub)),std(Min_corr(2,ValidSub)),'Color','k','LineWidth',2)
plot([1.2 2.8],[Min_corr(1,ValidSub); Min_corr(2,ValidSub)],'-','Color',[0.7 0.7 0.7],'LineWidth',0.5)
plot([1.2 2.8],[Min_corr(1,RepSubj); Min_corr(2,RepSubj)],'-','Color',[0 0 0],'LineWidth',0.5)
set(gca,'XTick',[])
ylabel('Minimum')
[h p t stats] = ttest(Min_corr(1,ValidSub),Min_corr(2,ValidSub));
title(['t =',num2str(round(stats.tstat,2)),',p =',num2str(p)])


figure(1000)
subplot(1,3,3)
hold on;
bar(1,mean(Std_corr(1,ValidSub)),'EdgeColor',ColorBar(:,1),'FaceColor',[1 1 1],'LineWidth',2)
errorbar(1,mean(Std_corr(1,ValidSub)),std(Std_corr(1,ValidSub)),'Color','k','LineWidth',2)
bar(3,mean(Std_corr(2,ValidSub)),'EdgeColor',ColorBar(:,2),'FaceColor',[1 1 1],'LineWidth',2)
errorbar(3,mean(Std_corr(2,ValidSub)),std(Std_corr(2,ValidSub)),'Color','k','LineWidth',2)
plot([1.2 2.8],[Std_corr(1,ValidSub); Std_corr(2,ValidSub)],'-','Color',[0.7 0.7 0.7],'LineWidth',0.5)
plot([1.2 2.8],[Std_corr(1,RepSubj); Std_corr(2,RepSubj)],'-','Color',[0 0 0],'LineWidth',0.5)
set(gca,'XTick',[])
ylabel('Width')
[h p t stats] = ttest(Std_corr(1,ValidSub),Std_corr(2,ValidSub));
title(['t =',num2str(round(stats.tstat,2)),',p =',num2str(p)])


