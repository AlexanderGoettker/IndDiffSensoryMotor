function [Vel_Vek Timing] = Comp_VelVek(vel,events);


Timing = [-100:25:500];

if events(3)-events(2) <= 550
    
    Vel_Vek(1:length(Timing))= NaN;
else
    
    
    for aa = 1:length(Timing)
        Vel_Vek(aa) = nanmedian(vel(events(2)+Timing(aa)-25:events(2)+Timing(aa)+25));
    end
end


