function [dev]= difference(p,y_emp,x)

y_pred= Gaussian(p,x);

% for aa = 1:length(y_pred)
%     if y_pred(aa) >  1 
%         y_pred(aa) = 1; 
%     end 
% end 

dev= nansum((y_emp(:)-y_pred(:)).^2);