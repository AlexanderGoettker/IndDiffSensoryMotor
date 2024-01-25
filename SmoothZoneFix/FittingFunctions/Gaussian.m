function [y]= gaussian (p,x)

%% Forumlation of the inverse Gaussian
y=(1/(p(2)*sqrt(2*pi)))* exp(-0.5*((x-p(1))/p(2)).^2); 
y= y/max(y); 
y= y* p(3); 
y = 1-y; 