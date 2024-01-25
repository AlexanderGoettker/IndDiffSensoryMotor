function [dev]= difference(p,y_emp,x)

%% Compute the Gaussian given the parameters
y_pred= Gaussian(p,x);

% Fix it asymptotacially to 1
for aa = 1:length(y_pred)
    if y_pred(aa) >  1 
        y_pred(aa) = 1; 
    end 
end 

% Compute the deviation
dev= nansum((y_emp(:)-y_pred(:)).^2);