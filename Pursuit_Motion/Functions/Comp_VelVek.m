function [Vel_Vek Timing] = Comp_VelVek(vel,events); 


Timing = [-100:25:600]; 



for aa = 1:length(Timing) 
        Vel_Vek(aa) = nanmean(vel(events(2)+Timing(aa)-50:events(2)+Timing(aa)+50));
end
    

