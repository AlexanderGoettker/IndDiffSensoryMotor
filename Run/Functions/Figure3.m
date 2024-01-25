function [] = Figure3(path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Script to create results for Figure 3 %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Load the merged Results file
load([path,'Merged Results'])

% Get the respective varialbes for plotting
select_purs = find(~isnan(Purs_Gain)); % For the correlations with pursuit, 1 subject needed to removed due to unreliable measurments
select = [1:50];

% Saccade Parameter
Sacc_Pos = Hor_Error(1,select);
Sacc_Vel = Hor_Error(2,select);

% Pursuit Parameter
Gain = Purs_Gain(select);
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
    PlotVektor(sub) = col;

    
    % Saccade to stationary + Pursuit to moving
   
    figure(10);
    hold on;
    
    plot(Sacc_Pos(sub),Gain(sub),'o','Color','k','MarkerFaceColor',Color(col,:));
    if sub == length(Subject)
        xlabel('Horizontal Error Position [deg]'); ylabel('Pursuit Gain')
        [x p] = corrcoef(Sacc_Pos(select_purs),Gain(select_purs));
        Corr_Correlation = x(1,2)/(sqrt(0.96*0.92));

        title(['Correlation: ', num2str(x(1,2)),', p =',num2str(p(1,2))])
        param  = polyfit(Sacc_Pos(select_purs),Gain(select_purs),1);
        if p(1,2)<.05
            plot([min(Sacc_Pos) max(Sacc_Pos)],[min(Sacc_Pos) max(Sacc_Pos)]*param(1)+param(2),'k-')
        else
            plot([min(Sacc_Pos) max(Sacc_Pos)],[min(Sacc_Pos) max(Sacc_Pos)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5])
        end
        ylim([0.6 1.2])
    end
    
    %Saccade to moving + Pursuit to moving
    figure(11);
    hold on;
    plot(Sacc_Vel(sub),Gain(sub),'o','Color','k','MarkerFaceColor',Color(col,:));
    xlabel('Horizontal Error Velocity [deg]'); ylabel('Pursuit Gain')
    if sub == length(Subject)
        [x p] = corrcoef(Sacc_Vel(select_purs),Gain(select_purs));
        Corr_Correlation = x(1,2)/(sqrt(0.98*0.92)); 
        
        title(['Correlation: ', num2str(x(1,2)),', p =',num2str(p(1,2))])
        param  = polyfit(Sacc_Vel(select_purs),Gain(select_purs),1);
        ylim([0.6 1.2])
        if p(1,2) < .05
            plot([min(Sacc_Vel) max(Sacc_Vel)],[min(Sacc_Vel) max(Sacc_Vel)]*param(1)+param(2),'k-')
        else
            plot([min(Sacc_Vel) max(Sacc_Vel)],[min(Sacc_Vel) max(Sacc_Vel)]*param(1)+param(2),'--','Color',[0.50 0.5 0.5])
            
        end
    end
    
    % Saccade to stationary + Pursuit to position
    figure(12);
    hold on;
    plot(Sacc_Pos(sub),Purs_Pos(sub),'o','Color','k','MarkerFaceColor',Color(col,:));
    
    if sub == length(Subject)
        xlabel('Horizontal Error Position [deg]'); ylabel('Influence Position Pursuit')
        [x p] = corrcoef(Sacc_Pos,Purs_Pos);
        Corr_Correlation = x(1,2)/(sqrt(0.96*0.42));

        title(['Correlation: ', num2str(x(1,2)),', p =',num2str(p(1,2))])
        param  = polyfit(Sacc_Pos,Purs_Pos,1);
        if p(1,2) < .05
            plot([min(Sacc_Pos) max(Sacc_Pos)],[min(Sacc_Pos) max(Sacc_Pos)]*param(1)+param(2),'k-')
        else
            plot([min(Sacc_Pos) max(Sacc_Pos)],[min(Sacc_Pos) max(Sacc_Pos)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5])
        end
    end
    
    % Saccade to Moving + Pursuit to position
    figure(13);
    hold on;
    plot(Sacc_Vel(sub),Purs_Pos(sub),'o','Color','k','MarkerFaceColor',Color(col,:));
    if sub == length(Subject)
        xlabel('Horizontal Error Velocity [deg]'); ylabel('Influence Position Pursuit')
        [x p] = corrcoef(Sacc_Vel,Purs_Pos);
        Corr_Correlation = x(1,2)/(sqrt(0.98*0.42));

        title(['Corrrelation: ', num2str(x(1,2)),', p =',num2str(p(1,2))])
        param  = polyfit(Sacc_Vel,Purs_Pos,1);
        if p(1,2) < .05
            plot([min(Sacc_Vel) max(Sacc_Vel)],[min(Sacc_Vel) max(Sacc_Vel)]*param(1)+param(2),'k-')
        else
            plot([min(Sacc_Vel) max(Sacc_Vel)],[min(Sacc_Vel) max(Sacc_Vel)]*param(1)+param(2),'--','Color',[0.5 0.5 0.5])
        end
    end
end

