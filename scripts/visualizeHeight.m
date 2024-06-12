function visualizeHeight(out)
% Description: 
% This function plots the variation in height of the four objects as they are rolling on the ramp
%-----------------
% Inputs:      
% out: The variable where the results of the Simulink model are stored
%-----------------
% Example:
% Provided that the model has been simulated, the height can be plotted by calling: 
% visualizeHeight(ssmInertia)
%-----------------
% Lorenzo Nicoletti, Last Update: 12.06.2024
%-----------------

% Set up the figure
figure('Units','centimeters','Position',[0,0,29.81/2,12.91]); hold on, grid on; 

% Set up labels and title:
xlabel('Simulation Time in sec');
ylabel('COG Position in meters');
title('COG Position along Z');
ax = gca; ax.FontSize = 12;

% Plot the objects' position (in Z) over time
plot(out.simlog.S.Height_sensor.pz.I.series.time,  out.simlog.S.Height_sensor.pz.I.series.values, 'LineWidth',2,'Color',[0,118,168]/255,'DisplayName','Sphere'); 
plot(out.simlog.HS.Height_sensor.pz.I.series.time, out.simlog.HS.Height_sensor.pz.I.series.values,'LineWidth',2,'Color',[215, 136, 36]/255,'DisplayName','Hollow sphere'); 
plot(out.simlog.C.Height_sensor.pz.I.series.time,  out.simlog.C.Height_sensor.pz.I.series.values, 'LineWidth',2,'Color',[0,0,0],'DisplayName','Cylinder'); 
plot(out.simlog.HC.Height_sensor.pz.I.series.time, out.simlog.HC.Height_sensor.pz.I.series.values,'LineWidth',2,'Color',[153,153,153]/255,'DisplayName','Hollow cylinder'); 

% Set legend position: 
legend('Location','best');

end