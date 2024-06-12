function visualizeEnergy(out,phys,objects)
% Description: 
% This function plots the variation in energy of the four objects as they are rolling on the ramp
%-----------------
% Inputs:      
% out:      The variable where the results of the Simulink model are stored
% physics : The variable storing the physics settings (created with the script simpleInertiaParam) 
% objects : The variable storing the dimensions of the objects (created with the script simpleInertiaParam)  
%-----------------
% Example:
% Provided that the model has been simulated, the height can be plotted by calling: 
% visualizeEnergy(ssmInertia,physics,objects)
%-----------------
% Lorenzo Nicoletti, Last Update: 12.06.2024
%-----------------

% Rewrite the variables in a more compact way: 
ssm = out.simlog;

% Simulation time
simTime = ssm.S.Height_sensor.pz.I.series.time;

% Calculate potential energy of the four objects. Subtract their radius so
% that the first object that reaches the edge of the ramp has a potential energy equal to zero
potentialEnergyS  = phys.mass*phys.g*(ssm.S.Height_sensor.pz.I.series.values-objects.sphereRad);
potentialEnergyHS = phys.mass*phys.g*(ssm.HS.Height_sensor.pz.I.series.values-objects.sphereRad);
potentialEnergyC  = phys.mass*phys.g*(ssm.C.Height_sensor.pz.I.series.values-objects.cylindRad);
potentialEnergyHC = phys.mass*phys.g*(ssm.HC.Height_sensor.pz.I.series.values-objects.cylindRad);

% Retrieve the inertia of the four objects:
inertiaS = ssm.S.Joint.J.I.series.values;
inertiaC = ssm.C.Joint.J.I.series.values;
inertiaHC = ssm.HC.Joint.J.I.series.values;
inertiaHS = ssm.HS.Joint.J.I.series.values;

% Calculate the kinetic energy of the four objects: 
kineticEnergyS  = 0.5*inertiaS(1,9).*ssm.S.Joint.w.I.series.values.^2 + 0.5*phys.mass*(ssm.S.Joint.v.I.series.values.^2);
kineticEnergyHS  = 0.5*inertiaHS(1,9).*ssm.HS.Joint.w.I.series.values.^2 + 0.5*phys.mass*(ssm.HS.Joint.v.I.series.values.^2);
kineticEnergyC  = 0.5*inertiaC(1,5).*ssm.C.Joint.w.I.series.values.^2 + 0.5*phys.mass*(ssm.C.Joint.v.I.series.values.^2);
kineticEnergyHC  = 0.5*inertiaHC(1,5).*ssm.HC.Joint.w.I.series.values.^2 + 0.5*phys.mass*(ssm.HC.Joint.v.I.series.values.^2);

% Calculate the lost energy: (due to damping and friction) 
lostEnergyS      = abs(squeeze(out.logsout.get('S').Values.Er.Data))+abs(out.logsout.get('S').Values.En.Data);
lostEnergyHS      = abs(squeeze(out.logsout.get('HS').Values.Er.Data))+abs(out.logsout.get('HS').Values.En.Data);
lostEnergyC      = abs(squeeze(out.logsout.get('C').Values.Er.Data))+abs(out.logsout.get('C').Values.En.Data);
lostEnergyHC      = abs(squeeze(out.logsout.get('HC').Values.Er.Data))+abs(out.logsout.get('HC').Values.En.Data);

% Plot for each object the energies:
plotEnergyCount(simTime,potentialEnergyS,kineticEnergyS,lostEnergyS,'Energy Sphere');
plotEnergyCount(simTime,potentialEnergyHS,kineticEnergyHS,lostEnergyHS,'Energy Hollow Sphere');
plotEnergyCount(simTime,potentialEnergyC,kineticEnergyC,lostEnergyC,'Energy Cylinder');
plotEnergyCount(simTime,potentialEnergyHC,kineticEnergyHC,lostEnergyHC,'Energy Hollow Cylinder');
end

%% Sub functions: 
function plotEnergyCount(simTime,potentialEnergy,kineticEnergy,lostEnergy,titleString)

    % Set up figure and figure labels
    figure('Units','centimeters','Position',[0,0,29.81/2,12.91]); hold on, grid on; 
    xlabel('Simulation Time in sec');
    ylabel('Energy in Joules');
    
    % Plot the results
    plot(simTime,potentialEnergy,'LineWidth',2,'Color',[0,118,168]/255); 
    plot(simTime, kineticEnergy,'LineWidth',2,'Color',[215, 136, 36]/255);
    plot(simTime, lostEnergy,'LineWidth',2,'Color',[0, 75, 135]/255);
    line([0,simTime(end)],[potentialEnergy(1),potentialEnergy(1)],'LineStyle','--','LineWidth',2,'Color','r');
    legend('Potential Enegry','Kinetic Energy','Lost Energy','Initial Energy','Location','best')
    
    % Add title and set axle limits
    title(titleString);
    ax = gca; ax.FontSize = 12; ax.YLim(1) = 0;
end