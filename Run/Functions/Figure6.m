function [] = Figure6(savepath)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Script to create results for Figure 6 %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Load the merged Results file
load([savepath,'Merged Results'])


%% Define the subjects
ValidSub = find(Center_corr(1,:) <= 399 & Center_corr(2,:) <= 399 & ~isnan(Purs_Latency));

%% Initialize plotting
set (0,'DefaultAxesFontSize',8)
set (0,'DefaultLineMarkerSize',4)
set (0,'DefaultAxesLineWidth',1)
warning off
Sacc_Vel = Hor_Error(2,:);
[a idx] = sort(Sacc_Vel); % Get the indexes for plotting
Color = cbrewer('seq','Greys',length(Subject)); % Colormap
Color(find(Color>1))= 1; Color(find(Color<=0))= 0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create the figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Center during Fixation
for sub = 1: length(Subject)
    if ismember(sub,ValidSub)
        
        % Get the correct color for this subject
        col = find(idx == sub);
        
        figure(21);
        hold on;
        
        subplot(2,4,1) % Pursuit Latency
        hold on;
        plot(Purs_Latency(sub),Center_corr(1,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            xlim([150 400])
            [x p] = corrcoef(Purs_Latency(ValidSub),Center_corr(1,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Purs_Latency(ValidSub),Center_corr(1,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Purs_Latency) max(Purs_Latency)],[min(Purs_Latency) max(Purs_Latency)]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Purs_Latency) max(Purs_Latency)],[min(Purs_Latency) max(Purs_Latency)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Pursuit Latency')
            ylim([100 400])
            ylabel('Center during Fixation')
        end;
        
        subplot(2,4,2) % Saccade Latency Moving
        hold on;
        plot(Sacc_Latency(2,sub),Center_corr(1,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            xlim([150 400])
            [x p] = corrcoef(Sacc_Latency(2,ValidSub),Center_corr(1,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Sacc_Latency(2,ValidSub),Center_corr(1,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Sacc_Latency(2,:)) max(Sacc_Latency(2,:))],[min(Sacc_Latency(2,:)) max(Sacc_Latency(2,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Sacc_Latency(2,:)) max(Sacc_Latency(2,:))],[min(Sacc_Latency(2,:)) max(Sacc_Latency(2,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Saccade Latency')
            ylim([100 400])
        end
        
        subplot(2,4,3)  % Saccade Error Position
        hold on;
        plot(Hor_Error(1,sub),Center_corr(1,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            
            [x p] = corrcoef(Hor_Error(1,ValidSub),Center_corr(1,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Hor_Error(1,ValidSub),Center_corr(1,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Hor_Error(1,:)) max(Hor_Error(1,:))],[min(Hor_Error(1,:)) max(Hor_Error(1,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Hor_Error(1,:)) max(Hor_Error(1,:))],[min(Hor_Error(1,:)) max(Hor_Error(1,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Saccade to Stationary')
            ylim([100 400])
        end
        
        subplot(2,4,4)  % Saccade Error Velocity
        hold on;
        plot(Hor_Error(2,sub),Center_corr(1,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(Hor_Error(2,ValidSub),Center_corr(1,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Hor_Error(2,ValidSub),Center_corr(1,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Hor_Error(2,:)) max(Hor_Error(2,:))],[min(Hor_Error(2,:)) max(Hor_Error(2,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Hor_Error(2,:)) max(Hor_Error(2,:))],[min(Hor_Error(2,:)) max(Hor_Error(2,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Saccade to Moving')
            ylim([100 400])
            xlim([-1.5 0])
        end
        
        subplot(2,4,5)  % Pursuit Acceleration
        hold on;
        plot(Purs_Acc(sub),Center_corr(1,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(Purs_Acc(ValidSub),Center_corr(1,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Purs_Acc(ValidSub),Center_corr(1,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Purs_Acc) max(Purs_Acc)],[min(Purs_Acc) max(Purs_Acc)]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Purs_Acc) max(Purs_Acc)],[min(Purs_Acc) max(Purs_Acc)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Pursuit Acceleration')
            ylabel('Center during Fixation')
            ylim([100 400])
        end
        
        subplot(2,4,6) % Pursuit Gain
        hold on;
        plot(Purs_Gain(sub),Center_corr(1,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(Purs_Gain(ValidSub),Center_corr(1,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Purs_Gain(ValidSub),Center_corr(1,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Purs_Gain) max(Purs_Gain)],[min(Purs_Gain) max(Purs_Gain)]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Purs_Gain) max(Purs_Gain)],[min(Purs_Gain) max(Purs_Gain)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Pursuit Gain')
            ylim([100 400])
            xlim([0.7 1.1])
        end
        
        subplot(2,4,7) % Sensitiivty Position
        hold on;
        plot(JND(1,sub),Center_corr(1,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(JND(1,ValidSub),Center_corr(1,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(JND(1,ValidSub),Center_corr(1,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(JND(1,:)) max(JND(1,:))],[min(JND(1,:)) max(JND(1,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(JND(1,:)) max(JND(1,:))],[min(JND(1,:)) max(JND(1,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Sensitivity Position')
            ylim([100 400])
            xlim([0 80])
        end
        
        subplot(2,4,8) % Sensitiivty Velocity
        hold on;
        plot(JND(2,sub),Center_corr(1,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            
            [x p] = corrcoef(JND(2,ValidSub),Center_corr(1,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(JND(2,ValidSub),Center_corr(1,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(JND(2,:)) max(JND(2,:))],[min(JND(2,:)) max(JND(2,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(JND(2,:)) max(JND(2,:))],[min(JND(2,:)) max(JND(2,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Sensitivity Motion')
            ylim([100 400])
        end
        
        %% Center during Pursuit
        figure(22);
        hold on;
        
        subplot(2,4,1) % Pursuit Latency
        hold on;
        plot(Purs_Latency(sub),Center_corr(2,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            xlim([150 400])
            [x p] = corrcoef(Purs_Latency(ValidSub),Center_corr(2,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Purs_Latency(ValidSub),Center_corr(2,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Purs_Latency) max(Purs_Latency)],[min(Purs_Latency) max(Purs_Latency)]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Purs_Latency) max(Purs_Latency)],[min(Purs_Latency) max(Purs_Latency)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Pursuit Latency')
            ylim([100 400])
        end
        
        subplot(2,4,2) % Saccade Latency Moving
        hold on;
        plot(Sacc_Latency(2,sub),Center_corr(2,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            xlim([150 400])
            [x p] = corrcoef(Sacc_Latency(2,ValidSub),Center_corr(2,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Sacc_Latency(2,ValidSub),Center_corr(2,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Sacc_Latency(2,:)) max(Sacc_Latency(2,:))],[min(Sacc_Latency(2,:)) max(Sacc_Latency(2,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Sacc_Latency(2,:)) max(Sacc_Latency(2,:))],[min(Sacc_Latency(2,:)) max(Sacc_Latency(2,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Saccade Latency')
            ylim([100 400])
        end
        
        subplot(2,4,3)  % Saccade Error Position
        hold on;
        plot(Hor_Error(1,sub),Center_corr(2,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(Hor_Error(1,ValidSub),Center_corr(2,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Hor_Error(1,ValidSub),Center_corr(2,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Hor_Error(1,:)) max(Hor_Error(1,:))],[min(Hor_Error(1,:)) max(Hor_Error(1,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Hor_Error(1,:)) max(Hor_Error(1,:))],[min(Hor_Error(1,:)) max(Hor_Error(1,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Saccade to Stationary')
            ylim([100 400])
        end
        
        subplot(2,4,4)  % Saccade Error Velocity
        hold on;
        plot(Hor_Error(2,sub),Center_corr(2,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(Hor_Error(2,ValidSub),Center_corr(2,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Hor_Error(2,ValidSub),Center_corr(2,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Hor_Error(2,:)) max(Hor_Error(2,:))],[min(Hor_Error(2,:)) max(Hor_Error(2,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Hor_Error(2,:)) max(Hor_Error(2,:))],[min(Hor_Error(2,:)) max(Hor_Error(2,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Saccade to Moving')
            ylim([100 400])
            xlim([-1.5 0])

        end
        
        subplot(2,4,5)  % Pursuit Acceleration
        hold on;
        plot(Purs_Acc(sub),Center_corr(2,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(Purs_Acc(ValidSub),Center_corr(2,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Purs_Acc(ValidSub),Center_corr(2,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Purs_Acc) max(Purs_Acc)],[min(Purs_Acc) max(Purs_Acc)]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Purs_Acc) max(Purs_Acc)],[min(Purs_Acc) max(Purs_Acc)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Pursuit Acceleration')
            ylabel('Center during Pursuit')
            ylim([100 400])
        end
        
        subplot(2,4,6) % Pursuit Gain
        hold on;
        plot(Purs_Gain(sub),Center_corr(2,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(Purs_Gain(ValidSub),Center_corr(2,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(Purs_Gain(ValidSub),Center_corr(2,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(Purs_Gain) max(Purs_Gain)],[min(Purs_Gain) max(Purs_Gain)]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(Purs_Gain) max(Purs_Gain)],[min(Purs_Gain) max(Purs_Gain)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Pursuit Gain')
            ylim([100 400])
            xlim([0.7 1.1])

        end
        
        subplot(2,4,7) % Sensitiivty Position
        hold on;
        plot(JND(1,sub),Center_corr(2,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(JND(1,ValidSub),Center_corr(2,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(JND(1,ValidSub),Center_corr(2,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(JND(1,:)) max(JND(1,:))],[min(JND(1,:)) max(JND(1,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(JND(1,:)) max(JND(1,:))],[min(JND(1,:)) max(JND(1,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Sensitivity Position')
            ylim([100 400])
            xlim([0 80])

        end
        
        subplot(2,4,8) % Sensitiivty Velocity
        hold on;
        plot(JND(2,sub),Center_corr(2,sub),'o','Color','k','MarkerFaceColor',Color(col,:))
        axis square
        if sub == length(Subject)
            [x p] = corrcoef(JND(2,ValidSub),Center_corr(2,ValidSub),'rows','complete');
            title(['Corr:',num2str(round(x(1,2),2))])
            param = polyfit(JND(2,ValidSub),Center_corr(2,ValidSub),1);
            if p(1,2) < 0.05
                plot([min(JND(2,:)) max(JND(2,:))],[min(JND(2,:)) max(JND(2,:))]*param(1)+param(2),'k-','LineWidth',1)
            else
                plot([min(JND(2,:)) max(JND(2,:))],[min(JND(2,:)) max(JND(2,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
            end
            xlabel('Sensitivity Motion')
            ylim([100 400])
        end
    end
end