function [xpos ypos events saccade pupil Bad_Trial] = load_eye(log_file,t);
% Function to load the raw eye data and convert them into deg

global datapath conv  Connector % Get the global data
Bad_Trial = 0;
%% Load the respective trial

file = load([datapath,log_file.name,Connector,'Trial',num2str(t)]);

%% Check which eye is the relevant one

if file.trial(1,2)==-32768 % Check where you find the default value of the EyeLink
    xpos = file.trial(:,5);
    ypos = file.trial(:,6);
elseif file.trial(1,5) ==-32768
    xpos = file.trial(:,2);
    ypos = file.trial(:,3);
elseif file.trial(1,2)~=-32768 & file.trial(1,5)~=-32768 % If you have data from both eyes
    xpos = mean([file.trial(:,2) file.trial(:,5)],2); % Average their estimate
    ypos = mean([file.trial(:,3) file.trial(:,6)],2);
end

%% Now convert the data into degree and center them

xpos= (xpos-conv.pix_x/2).*conv.ppd_x; % Convert into degree
ypos= (ypos-conv.pix_y/2).*conv.ppd_y.*-1; % Convert into degree and inverse them

events = find(file.trial(:,4) == 1) ; % Initialize the trial, start of the video, end of the video

saccades_raw = find(file.trial(:,7) == 1);  % These are the timepoints of all saccades
blinks_raw = find(file.trial(:,9) == 1); % Raw data for blinks
blinks = [];
pupil =  file.trial(:,8); % Pupil size
%% Detect saccade and blink on & offsets

number = find(diff(saccades_raw)> 1);
if isempty(saccades_raw)
    saccade = [];
else
    for aa = 1:length(number)+1
        if length(number) == 0
            saccade(aa,:)= [min(saccades_raw) max(saccades_raw)];
        else
            if aa == 1 % If it the first saccade
                saccade(aa,:) = [saccades_raw(1) saccades_raw(number(aa))];
            elseif aa == length(number)+1 % If it is the last saccade
                saccade(aa,:) = [saccades_raw(number(aa-1)+1) saccades_raw(end)];
                
            else
                saccade(aa,:) = [saccades_raw(number(aa-1)+1) saccades_raw(number(aa))];
            end
        end
    end
end
number = find(diff(blinks_raw)> 1);
if isempty(number)
    if ~isempty(blinks_raw)
        blinks = [min(blinks_raw) max(blinks_raw)];
    end
else
    for aa = 1:length(number)+1
        if aa == 1 % If it the first saccade
            blinks(aa,:) = [blinks_raw(1) blinks_raw(number(aa))];
        elseif aa == length(number)+1 % If it is the last saccade
            blinks(aa,:) = [blinks_raw(number(aa-1)+1) blinks_raw(end)];
            
        else
            blinks(aa,:) = [blinks_raw(number(aa-1)+1) blinks_raw(number(aa))];
        end
    end
end


% Remove saccades which contain a blink
for aa = 1: size(saccade,1)
    
    Vek = zeros(events(end),1);
    Vek(saccade(aa,1):saccade(aa,2)) = 1;
    
    check = find(Vek == 1 & file.trial(:,9) == 1);
    if ~isempty(check)
        saccade(aa,:) = NaN;
    end
    
end
if ~isempty(saccade)
    saccade = saccade(~isnan(saccade(:,1)),:);
end
%% Lineraly interpolate blinks
if ~isempty(blinks_raw)
    
    if ~isempty(blinks)
        for aa = 1: size(blinks,1)
            
            if blinks(aa,1) == 1
                xpos(blinks(aa,1):blinks(aa,2))= linspace(xpos(blinks(aa,2)+1),xpos(blinks(aa,2)+1),blinks(aa,2)-blinks(aa,1)+1);
                ypos(blinks(aa,1):blinks(aa,2))= linspace(xpos(blinks(aa,2)+1),ypos(blinks(aa,2)+1),blinks(aa,2)-blinks(aa,1)+1);
                
            elseif blinks(aa,2)-blinks(aa,1) > 500
                Bad_Trial = 1;
                break
            elseif blinks(aa,2) == length(xpos)
                xpos(blinks(aa,1):blinks(aa,2))= linspace(xpos(blinks(aa,1)-1),xpos(blinks(aa,1)-1),blinks(aa,2)-blinks(aa,1)+1);
                ypos(blinks(aa,1):blinks(aa,2))= linspace(xpos(blinks(aa,1)-1),xpos(blinks(aa,1)-1),blinks(aa,2)-blinks(aa,1)+1);
                
            else
                xpos(blinks(aa,1):blinks(aa,2))= linspace(xpos(blinks(aa,1)-1),xpos(blinks(aa,2)+1),blinks(aa,2)-blinks(aa,1)+1);
                ypos(blinks(aa,1):blinks(aa,2))= linspace(ypos(blinks(aa,1)-1),ypos(blinks(aa,2)+1),blinks(aa,2)-blinks(aa,1)+1);
                
            end
        end
    else
        if max(blinks_raw) == length(xpos)
            
            xpos(min(blinks_raw):max(blinks_raw))= linspace(xpos(min(blinks_raw)-1),xpos(min(blinks_raw)-1),max(blinks_raw)-min(blinks_raw)+1);
            ypos(min(blinks_raw):max(blinks_raw))= linspace(ypos(min(blinks_raw)-1),ypos(min(blinks_raw)-1),max(blinks_raw)-min(blinks_raw)+1);
        elseif  max(blinks_raw) - min(blinks_raw) > 500
            Bad_Trial = 1;
        elseif min(blinks_raw) == 1
            xpos(min(blinks_raw):max(blinks_raw))= linspace(xpos(max(blinks_raw)+1),xpos(max(blinks_raw)+1),max(blinks_raw)-min(blinks_raw)+1);
            ypos(min(blinks_raw):max(blinks_raw))= linspace(ypos(max(blinks_raw)+1),ypos(max(blinks_raw)+1),max(blinks_raw)-min(blinks_raw)+1);
            
        else
            xpos(min(blinks_raw):max(blinks_raw))= linspace(xpos(min(blinks_raw)-1),xpos(max(blinks_raw)+1),max(blinks_raw)-min(blinks_raw)+1);
            ypos(min(blinks_raw):max(blinks_raw))= linspace(ypos(min(blinks_raw)-1),ypos(max(blinks_raw)+1),max(blinks_raw)-min(blinks_raw)+1);
        end
    end
end



