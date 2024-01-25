function [metrics] = compute_Average(metrics,sub,exp,subject)

Speed = unique(sub.speed(exp,subject,:));

for loop_speed = 1:length(Speed)
        
comb = find(sub.Bad_Trial(exp,subject,:) == 0 & sub.speed(exp,subject,:) == Speed(loop_speed) ); 
metrics.Error(exp,subject,loop_speed,:) = [nanmean(sub.sacc_error(exp,subject,comb)) nanstd(sub.sacc_error(exp,subject,comb))];
metrics.HorError(exp,subject,loop_speed,:) = [nanmean(sub.hor_error(exp,subject,comb)) nanstd(sub.hor_error(exp,subject,comb))];
metrics.VerError(exp,subject,loop_speed,:) = [nanmean(sub.vert_error(exp,subject,comb)) nanstd(sub.vert_error(exp,subject,comb))];
metrics.Latency(exp,subject,loop_speed,:) = [nanmean(sub.sacc_latency(exp,subject,comb)) nanstd(sub.sacc_latency(exp,subject,comb))];
metrics.Amplitude(exp,subject,loop_speed,:) = [nanmean(sub.amplitude(exp,subject,comb)) nanstd(sub.amplitude(exp,subject,comb))];

%% Compute the reliability of the individual measures based on an odd-even split
odd = [1:2:length(comb)]; even = [2:length(comb)]; 
metrics.ReliableError(exp,subject,loop_speed,:) = [nanmean(sub.sacc_error(exp,subject,comb(odd))) nanmean(sub.sacc_error(exp,subject,comb(even)))];
metrics.ReliableHorError(exp,subject,loop_speed,:) = [nanmean(sub.hor_error(exp,subject,comb(odd))) nanmean(sub.hor_error(exp,subject,comb(even)))];
metrics.ReliableVerError(exp,subject,loop_speed,:) = [nanmean(sub.vert_error(exp,subject,comb(odd))) nanmean(sub.vert_error(exp,subject,comb(even)))];
metrics.ReliableLatency(exp,subject,loop_speed,:) = [nanmean(sub.sacc_latency(exp,subject,comb(odd))) nanmean(sub.sacc_latency(exp,subject,comb(even)))];
metrics.ReliableAmplitude(exp,subject,loop_speed,:) = [nanmean(sub.amplitude(exp,subject,comb(odd))) nanmean(sub.amplitude(exp,subject,comb(even)))];

end


Dir = unique(sub.direction(exp,subject,:));

for loop_size = 1:length(Dir)
        for loop_speed = 1:length(Speed)

comb = find(sub.Bad_Trial(exp,subject,:) == 0 & sub.speed(exp,subject,:) == Speed(loop_speed) & sub.direction(exp,subject,:) == Dir(loop_size) ); 
metrics.DIRError(exp,subject,loop_size,loop_speed,:) = [nanmean(sub.sacc_error(exp,subject,comb)) nanstd(sub.sacc_error(exp,subject,comb))];
metrics.DIRHorError(exp,subject,loop_size,loop_speed,:) = [nanmean(sub.hor_error(exp,subject,comb)) nanstd(sub.hor_error(exp,subject,comb))];
metrics.DIRVerError(exp,subject,loop_size,loop_speed,:) = [nanmean(sub.vert_error(exp,subject,comb)) nanstd(sub.vert_error(exp,subject,comb))];
metrics.DIRLatency(exp,subject,loop_size,loop_speed,:) = [nanmean(sub.sacc_latency(exp,subject,comb)) nanstd(sub.sacc_latency(exp,subject,comb))];
metrics.DIRAmplitude(exp,subject,loop_size,loop_speed,:) = [nanmean(sub.amplitude(exp,subject,comb)) nanstd(sub.amplitude(exp,subject,comb))];
        end
end
