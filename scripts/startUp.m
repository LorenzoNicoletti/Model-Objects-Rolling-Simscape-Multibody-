%% Description: 
% 
% This is the startup script used by the project file
% Lorenzo Nicoletti, Last Update: 12.06.2024

% clear data
clear 

% Open the Model
open_system("simpleInertiaModel.slx");

% Load the Parametrization script:
edit simpleInertiaModelParam;
