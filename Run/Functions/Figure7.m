function [] = FigureTrigger(savepath)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Script to explore SaccTrigger %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Load the merged Results file
load([savepath,'Merged Results'])

ValidSub = find(Center_corr(1,:) <= 399 & Center_corr(2,:) <= 399); % Select subjects that have a fitted zone that is within the measured range

%% Initialize plotting
set (0,'DefaultAxesFontSize',16)
set (0,'DefaultLineMarkerSize',12)
set (0,'DefaultAxesLineWidth',1)
warning off
Sacc_Vel = Hor_Error(2,:);
[a idx] = sort(Sacc_Vel); % Get the indexes for plotting
Color = cbrewer('seq','Greys',length(Subject)); % Colormap
Color(find(Color>1))= 1; Color(find(Color<=0))= 0;



%% Get the quality of the Smooth Zone Fit
for exp =1:2
    
    disp(['R2 of the Fit is : ',num2str(mean(R2(exp,ValidSub))), 'Std: ', num2str(std(R2(exp,ValidSub)))]);
    disp(['RMSE of the Fit is : ',num2str(mean(RMSE(exp,ValidSub)))]);
    
    %% Look at which measurement people trigger there saccade for each stepsize
    
    [coef,pval] = partialcorr([Hor_Error(2,ValidSub); Purs_Gain(ValidSub); Center_corr(exp,ValidSub)]');
    Mat = [Hor_Error(2,ValidSub); Purs_Gain(ValidSub); Center_corr(exp,ValidSub); Purs_Latency(ValidSub); nanmean(squeeze(abs(PETrig(exp,ValidSub,:))),2)']';
    T = array2table(Mat);
    T.Properties.VariableNames = {'SaccError','PursGain','Interaction','PursLatency','PETriggerError'};
    writetable(T,['Interaction',num2str(exp)])
    
    %% Now look at the saccade trigger and its relation to saccade performance
    
  
    for sub = 1: length(Subject)
        if ismember(sub,ValidSub)
            
            % Get the correct color for this subject
            col = find(idx == sub);
            
            figure(100000+exp);
            hold on;
            
            plot(Hor_Error(2,sub),nanmean(squeeze(abs(PETrig(exp,sub,:)))),'o','Color','k','MarkerFaceColor',Color(col,:))
            if sub == length(Subject)
                [x p] = corrcoef(Hor_Error(2,ValidSub),nanmean(squeeze(abs(PETrig(exp,ValidSub,:))),2),'rows','complete');
                title(['Corr:',num2str(round(x(1,2),2)), ', p = ',num2str(round(p(1,2),2))])
                
                param = polyfit(Hor_Error(2,ValidSub),nanmean(squeeze(abs(PETrig(exp,ValidSub,:))),2)',1);
                if p(1,2) < 0.05
                    plot([min(Hor_Error(2,:)) max(Hor_Error(2,:))],[min(Hor_Error(2,:)) max(Hor_Error(2,:))]*param(1)+param(2),'k-','LineWidth',1)
                else
                    plot([min(Hor_Error(2,:)) max(Hor_Error(2,:))],[min(Hor_Error(2,:)) max(Hor_Error(2,:))]*param(1)+param(2),'--','Color',[0.5 0.5 0.5],'LineWidth',1)
                end
                xlabel('Saccade Error moving')
                ylabel('PETrigger')
                ylim([0 2])
                
            end
        end
    end    
end


