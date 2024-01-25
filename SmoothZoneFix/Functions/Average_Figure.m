function Average_Figure(metrics,sub)
close all
global resultpath

Plot_Map = [0.8 1.8; 1.2 2.2]';
Color = {'b','g'};
Labels = {'3deg Saccade', '10 deg Saccade'};
for subject = 1:size(metrics.Error,2)
    for loop_contrast = 1:2
        for loop_size= 1:2
    
            figure(subject)
            hold on;
            errorbar(Plot_Map(loop_size,loop_contrast),metrics.Error(1,subject,loop_size,loop_contrast,1),metrics.Error(1,subject,loop_size,loop_contrast,2),'o','Color',Color{loop_contrast})
            xlim([0.5 2.5])
            set(gca,'XTick',[1 2])
            set(gca,'XTickLabel',Labels)
            
             figure(100+subject)
            hold on;
            errorbar(Plot_Map(loop_size,loop_contrast),metrics.Gain(1,subject,loop_size,loop_contrast,1),metrics.Gain(1,subject,loop_size,loop_contrast,2),'o','Color',Color{loop_contrast})
            xlim([0.5 2.5])
            set(gca,'XTick',[1 2])
            set(gca,'XTickLabel',Labels)
            
              figure(200+subject)
            hold on;
            errorbar(Plot_Map(loop_size,loop_contrast),metrics.Latency(1,subject,loop_size,loop_contrast,1),metrics.Latency(1,subject,loop_size,loop_contrast,2),'o','Color',Color{loop_contrast})
            xlim([0.5 2.5])
            set(gca,'XTick',[1 2])
            set(gca,'XTickLabel',Labels)
    
        end
    end
end

figure(1)
print([resultpath,'Average Position Error'],'-dtiff')
