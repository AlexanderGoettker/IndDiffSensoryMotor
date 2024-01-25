function [metrics] = compute_Average(metrics,sub,exper,subject,Figure,SubNum)


%% Compute things based on the presented TX 
Size = unique(sub.tx(exper,subject,:));

for loop_size = 1:length(Size)
    
    comb = find(sub.Bad_Trial(exper,subject,:) == 0 & sub.tx(exper,subject,:) == Size(loop_size) );
    
    metrics.PropSacc(exper,subject,loop_size) = mean(sub.sacc(exper,subject,comb));
    metrics.PE(exper,subject,loop_size) = median(sub.PE(exper,subject,comb));
    metrics.RS(exper,subject,loop_size) = mean(sub.RS(exper,subject,comb));

end

%% Now look into when saccades are triggered
for loop_size = 1:length(Size)
    
    % Find all relevant trials including a saccade
    comb = find(sub.Bad_Trial(exper,subject,:) == 0 & sub.tx(exper,subject,:) == Size(loop_size) & sub.sacc(exper,subject,:) == 1);
    
    metrics.EXTrig(exper,subject,loop_size) = nanmean(sub.EXTrig(exper,subject,comb));
    metrics.PETrig(exper,subject,loop_size) = nanmedian(sub.PETrig(exper,subject,comb));
    metrics.RSTrig(exper,subject,loop_size) = nanmean(sub.RSTrig(exper,subject,comb));
    metrics.Latency(exper,subject,loop_size) = nanmean(sub.Latency(exper,subject,comb));

end
%% Fit the smooth zone for the corrected TX 

% get the Values
comb = find(sub.Bad_Trial(exper,subject,:) == 0) ; 
EX= squeeze(sub.TX_calc(exper,subject,comb)); 
Num = squeeze(sub.sacc(exper,subject,comb)); 

% Define a search range 
vektor= [-100 0 50 100 150 200 250 300 350 400];
% For the steps of the range
for loop= 1:length(vektor)-1
    
    comb= find (EX >= vektor(loop) &   EX < vektor(loop+1));
    vektor_time(loop) = median([EX(comb)]); % Get the x-position

    
    if isempty(comb)
        Results_trial(loop,1)= 0;
        Results(loop,1)= 0;
    else
        Results(loop,1)= nanmean(Num(comb)); % Compute the proportion of trials 
        Results_trial(loop,1)= length(comb);
    end
    

end

% Prepare the fitting
comb = find( Results_trial > 3); % For beeing included, there needs to be at least 3 trials 
Results_Matrix_ex(1,:)= vektor_time(comb);Results_Matrix_ex(2,:) = Results(comb); % Put them into a Matrix 

%% Fit the inverse Gaussian
optionsMinsearch = optimset('MaxFunEvals',50000,'MaxIter',50000,'TolFun', 1e-12, 'TolX',1e-12);
popt_tx = fminsearchbnd(@difference_function,[200 30 0.5 ],[-400 0 0 ],[400 300 1 ], optionsMinsearch,Results_Matrix_ex(2,:), Results_Matrix_ex(1,:));

Fine_X= linspace(min(Results_Matrix_ex(1,:)), max(Results_Matrix_ex(1,:)), 1000);
Fit_Exp  = Gaussian(popt_tx,Fine_X); % Get the fitting curve


if Figure & strcmp(SubNum,'15') % Figure for paper
    figure
subplot(1,2,1)
hold on; 
bar(Results_Matrix_ex(1,:),Results_Matrix_ex(2,:),'FaceColor',[1 1 1],'EdgeColor','b'); 
hold on; 
plot(Fine_X,Fit_Exp,'-','LineWidth',3,'Color','b')

end

%% Compute the quality of the fit
% Explained Variance
[x p] = corrcoef(Results_Matrix_ex(2,:),Gaussian(popt_tx,Results_Matrix_ex(1,:))); 
metrics.R2 (exper,subject) = x(1,2).^2;
% RMSE
metrics.RMSE(exper,subject) = sqrt(mean((Results_Matrix_ex(2,:)-Gaussian(popt_tx,Results_Matrix_ex(1,:))).^2));

% Save the fitting parameters
popt_tx(3) = 1-popt_tx(3); % Flip parameter 3, so it reflects the location of the troph
metrics.popt_tx(exper,subject,:) = popt_tx; 


