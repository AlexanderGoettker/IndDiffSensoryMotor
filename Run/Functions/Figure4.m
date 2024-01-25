function [] = Figure4(savepath)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Script to create results for Figure 3 %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Load the merged Results file
load([savepath,'Merged Results'])

% Get the respective varialbes for plotting
select_purs = find(~isnan(Purs_Gain));% For the correlations with pursuit, 1 subject needed to removed due to unreliable measurments
select = [1:50];

% Saccade Parameter
Sacc_Pos = Hor_Error(1,select);
Sacc_Vel = Hor_Error(2,select);
Sacc_Vert = Ver_Error(1,select);
Sacc_Vert_Movement = Ver_Error(2,select);

% Pursuit Parameter
Gain = Purs_Gain(select);
Gain_P = GainPsycho(select);
Purs_Pos = Purs_Effect_vel(select);


%% Set default values for plotting
set (0,'DefaultAxesFontSize',16)
set (0,'DefaultLineMarkerSize',12)
set (0,'DefaultAxesLineWidth',1)
warning off

[a idx] = sort(Sacc_Vel); % Get the indexes for plotting
Color = cbrewer('seq','Greys',length(Subject)); % Colormap
Color(find(Color>1))= 1; Color(find(Color<=0))= 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for sub = 1:length(Subject)
    
    % Get the correct color for this subject
    col = find(idx == sub);
    
    % Horizontal error of Saccade to stationary + Horizontal error of Saccade to moving
    figure(14);
    hold on;
    plot(Sacc_Pos(sub),Sacc_Vel(sub),'o','Color','k','MarkerFaceColor',Color(col,:));
    if sub == length(Subject)
        xlabel('Horizontal Saccade Error Position'); ylabel('Horizontal Saccade Error Velocity')
        [x p] = corrcoef(Sacc_Pos,Sacc_Vel);
        title(['Correlation: ', num2str(x(1,2)),', p =',num2str(p(1,2))])
        param  = polyfit(Sacc_Pos,Sacc_Vel,1); plot([min(Sacc_Pos) max(Sacc_Pos)],[min(Sacc_Pos) max(Sacc_Pos)]*param(1)+param(2),'k-')
        Corr_Sacc_Diff = x(1,2); % Save the correlation for this conditions
    end
    
    % Vertical error of Saccade to stationary + Vertical error of Saccade to moving
    figure(15);
    hold on;
    plot(Sacc_Vert(sub),Sacc_Vert_Movement(sub),'o','Color','k','MarkerFaceColor',Color(col,:));
    if sub == length(Subject)
        xlabel('Vertical Saccade Error Position'); ylabel('Vertical Saccade Error Velocity')
        [x p] = corrcoef(Sacc_Vert,Sacc_Vert_Movement);
        title(['Correlation: ', num2str(x(1,2)),', p =',num2str(p(1,2))])
        param  = polyfit(Sacc_Vert,Sacc_Vert_Movement,1); plot([min(Sacc_Vert) max(Sacc_Vert)],[min(Sacc_Vel) max(Sacc_Vert)]*param(1)+param(2),'k-')
        Corr_Sacc_Same = x(1,2); % Save the correlation for this conditions
    end
    
    % Pursuit to velocity + Pursuit to position
    figure(16);
    hold on;
    plot(Gain(sub),Purs_Pos(sub),'o','Color','k','MarkerFaceColor',Color(col,:));
    if sub == length(Subject)
        xlabel('Gain Pursuit Task'); ylabel('Influence Pursuit Position')
        [x p] = corrcoef(Gain(select_purs),Purs_Pos(select_purs));
        title(['Correlation: ', num2str(x(1,2)),', p =',num2str(p(1,2))])
        param  = polyfit(Gain(select_purs),Purs_Pos(select_purs),1);
        if p(1,2) < .05
            plot([min(Gain) max(Gain)],[min(Gain) max(Gain)]*param(1)+param(2),'k-')
        else
            plot([min(Gain) max(Gain)],[min(Gain) max(Gain)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5])
        end
        Corr_Purs_Diff = x(1,2); % Save the correlation for this conditions
    end
    
    % Pursuit to velocity + Pursuit to velocity in Psychophysics Task
    figure(17);
    hold on;
    plot(Gain(sub),Gain_P(sub),'o','Color','k','MarkerFaceColor',Color(col,:));
    if sub == length(Subject)
        xlabel('Gain Pursuit Task'); ylabel('Gain Perceptual Task')
        [x p] = corrcoef(Gain(select_purs),Gain_P(select_purs));
        title(['Correlation: ', num2str(x(1,2)),', p =',num2str(p(1,2))])
        param  = polyfit(Gain(select_purs),Gain_P(select_purs),1);
        if p(1,2) < .05
            plot([min(Gain) max(Gain)],[min(Gain) max(Gain)]*param(1)+param(2),'k-')
        else
            plot([min(Gain) max(Gain)],[min(Gain) max(Gain)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5])
        end
        Corr_Purs_Same = x(1,2); % Save the correlation for this conditions
    end
end

%% Estimate the relative contributions of sensory and motor variance

figure(18);
hold on;
bar(2,Corr_Purs_Same.^2,'FaceColor','k','EdgeColor','k')
bar(2,Corr_Purs_Diff.^2,'FaceColor','w','EdgeColor','k')
bar(1,Corr_Sacc_Same.^2,'FaceColor','k','EdgeColor','k')
bar(1,Corr_Sacc_Diff.^2,'FaceColor','w','EdgeColor','k')
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',{'Saccade','Pursuit'})
ylabel('Explained Variance [%]');


Sensory_Variance_Sacc = (Corr_Sacc_Same.^2-Corr_Sacc_Diff.^2)/Corr_Sacc_Same.^2;
Sensory_Variance_Purs = (Corr_Purs_Same.^2-Corr_Purs_Diff.^2)/Corr_Purs_Same.^2;

