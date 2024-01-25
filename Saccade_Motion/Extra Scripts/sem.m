function [xx] = sem (yy)

data =yy ;
std_data = std(data);
samples = length(data); 

xx = std_data/sqrt(samples); 
