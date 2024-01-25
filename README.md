# Individual differences link sensory processing and motor control

Here you can find the analysis code for our project on how interindividual differences are related across different oculomotor and psychophysical tasks. 

The raw data can be with explanations can be found here: https://doi.org/10.23668/psycharchives.12502

For running the analysis you need to download the data from here: https://osf.io/d5rw7/
which has them in the required MATLAB format. 
____________________________________________________________________________________________________________

There are two ways to analyze the data: 

(1) In the different folders you find code to either run the analysis for each of the eight experiment seperately (Saccade_Postion, Saccade_Motion, Pursuit_Position, Pursuit_Motion, Psycho_Position, Psycho_Motion, SmoothZoneFix or SmoothZonePurs), by selecting the 'Main' Script that is available in each folder. 

(2) You can analyze all experiments together, by going to the 'Run' folder and selecting the 'Run' Script, that runs the analysis for all experiments together and reproduces all figures that are shown in the manuscript. It does so by looping through the individual experiment folders and loading the 'MainFunction' script available in each of them. 

The code and each function themself is documented to explain the individual steps of the analysis. 

Please note that the major thing you need to adjust is the paths that lead to the folders where you saved the downloaded data, and to the 'ResultsClean' folder available here with the analysis, where the results for each experiment are saved. 
Please note that to allow for some flexibility in how and where to store the data, each of the Main and MainFunction Scripts for the individual experiments has their own defintion of where to find the data, so you will need to adjust them there as well and not only in the run folder. 

The ideal Structure for the analysis would be a main folder for the experiment, a 'Data' folder which contains all of the downloaded data, a 'Analysis' folder, which contains the folders for each of the individual experiments + the 'Run' folder, and as a third folder the ResultsClean folder also available here. 






