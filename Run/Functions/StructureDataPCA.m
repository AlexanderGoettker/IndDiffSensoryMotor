function [] = StructreDataPCA(savepath)

load([savepath,'Merged Results'])

%% Read out the data for the PCA Matrix 
ValidSub = find(~isnan(Purs_Latency)); % Get all participants who have a valid pursuit measurment

Mat = [Hor_Error(1,ValidSub); Hor_Error(2,ValidSub); Ver_Error(1,ValidSub); Ver_Error(2,ValidSub);Sacc_Latency(1,ValidSub); Sacc_Latency(2,ValidSub);...
       Purs_Gain(ValidSub); Purs_Acc(ValidSub); Purs_Effect_vel(ValidSub); Purs_Latency(ValidSub)]';

T = array2table(Mat); 
T.Properties.VariableNames = {'Hor Sacc Position','Hor Sacc Velocity','Ver Sacc Position','Ver Sacc Velocity',...
    'Sacc Latency Pos','Sacc Latency Vel','Purs Gain','Purs Acc','Purs Position','Purs Latency'};

writetable(T,'PCAData')

   
 