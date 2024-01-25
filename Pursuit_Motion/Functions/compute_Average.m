function [metrics] = compute_Average(metrics,sub,exp,subject)

% Define things
Speed = unique(sub.speed(exp,subject,:));
Color = cbrewer('qual','Dark2',3);
Mat = [];
Mat_Sacc = [];

%% Loop through the different speeds
for loop_speed = 1:length(Speed)


    comb = find(sub.Bad_Trial(exp,subject,:) == 0 & sub.speed(exp,subject,:) == Speed(loop_speed) );
    metrics.Latency(exp,subject,loop_speed,:) = [nanmedian(sub.Latency(exp,subject,comb)) nanstd(sub.Latency(exp,subject,comb))];
    metrics.Acc(exp,subject,loop_speed,:) = [nanmedian(sub.Acc(exp,subject,comb)) nanstd(sub.Acc(exp,subject,comb))];
    metrics.Gain(exp,subject,loop_speed,:) = [nanmedian(sub.Gain(exp,subject,comb)) nanstd(sub.Gain(exp,subject,comb))];
    metrics.SaccRate(exp,subject,loop_speed,:) = [nanmean(sub.Sacc(exp,subject,comb)) nanstd(sub.Sacc(exp,subject,comb))];

    metrics.Vel(:,exp,subject,loop_speed) = nanmedian(squeeze(sub.VelVek(:,exp,subject,comb)),2);


    %% Compute the reliability

    odd = [1:2:length(comb)]; even =  [2:2:length(comb)];

    metrics.ReliabilityLatency(exp,subject,loop_speed,:) = [nanmedian(sub.Latency(exp,subject,comb(odd))) nanmedian(sub.Latency(exp,subject,comb(even)))];
    metrics.ReliabilityGain(exp,subject,loop_speed,:) = [nanmedian(sub.Gain(exp,subject,comb(odd))) nanmedian(sub.Gain(exp,subject,comb(even)))];
    metrics.ReliabilityAcc(exp,subject,loop_speed,:) = [nanmedian(sub.Acc(exp,subject,comb(odd))) nanmedian(sub.Acc(exp,subject,comb(even)))];

end

%% Look at the direction effect

Dir = unique(sub.dir(exp,subject,comb));
for loop_dir = 1:length(Dir)
    for loop_speed = 1:length(Speed)


        comb = find(sub.Bad_Trial(exp,subject,:) == 0 & sub.dir(exp,subject,:) == Dir(loop_dir) & sub.speed(exp,subject,:) == Speed(loop_speed) );
        metrics.DIRLatency(exp,subject,loop_speed,loop_dir,:) = [nanmedian(sub.Latency(exp,subject,comb)) nanstd(sub.Latency(exp,subject,comb))];
        metrics.DIRAcc(exp,subject,loop_speed,loop_dir,:) = [nanmedian(sub.Acc(exp,subject,comb)) nanstd(sub.Acc(exp,subject,comb))];
        metrics.DIRGain(exp,subject,loop_speed,loop_dir,:) = [nanmedian(sub.Gain(exp,subject,comb)) nanstd(sub.Gain(exp,subject,comb))];
        metrics.DIRSaccRate(exp,subject,loop_speed,loop_dir,:) = [nanmean(sub.Sacc(exp,subject,comb)) nanstd(sub.Sacc(exp,subject,comb))];

        if  metrics.DIRGain(exp,subject,loop_speed,loop_dir,1) == 0
            keyboard
        end
    end
end


