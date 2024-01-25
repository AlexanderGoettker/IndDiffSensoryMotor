function [conv] = setup(pix_x,pix_y,mon_height,mon_width,v_dist,Sample_Eye, Sample_Disp);

%% Function to compute basic concepts with respect to the setup
global datapath

conv.pix_x = pix_x; % Pixel X
conv.pix_y = pix_y; % Pixel Y
conv.mon_height= mon_height; % Mon Height
conv.mon_width= mon_width; % Mon Width
conv.v_dist = v_dist; % View Dist

conv.ppd_x = atand((conv.mon_width/conv.pix_x)/conv.v_dist); % Pixel per Degree X
conv.ppd_y= atand((conv.mon_height/conv.pix_y)/conv.v_dist); % Pixel per Degree Y

conv.freq_eye = Sample_Eye; % Frequency of tracker
conv.freq_disp = Sample_Disp; % Frequency of monitor

%% get the filter values 
load([datapath,'filtervariables'])
conv.posfil_a = posfil_a; 
conv.posfil_b = posfil_b;
conv.velfil_c = velfil_c;
conv.velfil_d = velfil_d;

