%   Erkin Verbeek
%   Per Sebastian Skardal

tic

%% Decide the type of simulation to be run
modelType = 'SIS';  % options: SIS, SIR

simType = 'BinaryVsODE_PointGraph'; % options:  Binary, ODE, 
% Binary_RInf, ODE_RInf, BinaryVsODE, BinaryVsODE_RInf, 
% BinaryVsODE_PointGraph, Binary_Special, ErrorChecking, ODE_VaccineTesting


%% Define simulation parameters

N = 400;       % Number of nodes
k = 8;         % Mean degree (average nodal degree)

simulationLength = 150;  % Length of time each simulation runs for
deltaT = 0.50;          % Granularity of each time unit

cutOffTime = 100;    % how many seconds into the simulation to switch from
%transient to steady state (TODO replace this with more dynamic approach?)

initialInfectionChance = 0.02;    % chance a random node starts infected

beta = 0.04;    % Infection rate
gamma = 0.15;   % Recovery rate


saveFig = false;     % save .fig file to Figures folder?

% beta range specific values (only used with simulations that need
% mutliple beta values option)
if (strcmp(simType, 'Binary_RInf') || ...
        strcmp(simType, 'ODE_RInf') || ...
        strcmp(simType, 'Jacobian_Test') || ...
        strcmp(simType, 'BinaryVsODE_RInf') || ...
        strcmp(simType, 'ODE_VaccineTesting'))
    
    
    % the range of beta values to consider (overwrites beta value above)
    betaValueMax = 0.28;
    betaValueMin = 0.0;
    deltaBeta = 0.0025;   % granularity between different beta values
end

% Move simulation parameter values to a single struct
Parameters = struct;
Parameters.modelType = modelType;
Parameters.simType = simType;
Parameters.N = N;
Parameters.k = k;
Parameters.beta = beta;
Parameters.gamma = gamma;
Parameters.length = simulationLength;
Parameters.deltaT = deltaT;
Parameters.cutOffTime = cutOffTime;

Parameters.saveFig = saveFig;
Parameters.initialInfectionChance = initialInfectionChance;
if (strcmp(simType, 'Binary_RInf') || ...
        strcmp(simType, 'ODE_RInf') || ...
        strcmp(simType, 'Jacobian_Test') || ...
        strcmp(simType, 'BinaryVsODE_RInf') || ...
        strcmp(simType, 'ODE_VaccineTesting'))
    Parameters.beta = [];
    Parameters.SteadyState.betaValues = betaValueMin:deltaBeta:betaValueMax;
    Parameters.SteadyState.deltaBeta = deltaBeta;
end

% removes unecessary duplicate variables
clearvars("-except", "Parameters");

%% Call specific functions depending on the simulation choice

switch Parameters.modelType
    % SIS Model
    case "SIS"
        switch Parameters.simType
            case "Binary"
                SIS_Model.SimAndPlot_Binary(Parameters);
            case "Binary_RInf"
                SIS_Model.SimAndPlot_Binary_RInf(Parameters);

            case "ODE"
                SIS_Model.SimAndPlot_ODE(Parameters);
            case "ODE_RInf"
                SIS_Model.SimAndPlot_ODE_RInf(Parameters);
            case "ODE_VaccineTesting"
                SIS_Model.SimAndPlot_ODE_VaccineTesting(Parameters);
                
                

            case "BinaryVsODE"
                SIS_Model.SimAndPlot_BinaryVsODE(Parameters);    
            case "BinaryVsODE_RInf"
                SIS_Model.SimAndPlot_BinaryVsODE_RInf(Parameters);

            case "BinaryVsODE_PointGraph"
                SIS_Model.SimAndPlot_BinaryVsODE_PointGraph(Parameters);
            case 'Jacobian_Test'
                SIS_Model.Jacobian_Test(Parameters);
                
            case 'ErrorChecking'
                SIS_Model.ErrorChecking(Parameters);
        end
        
        
    % SIR Model
    case "SIR"
        switch Parameters.simType
            case "Binary"
                SIR_Model.SimAndPlot_Binary(Parameters);
            case "Binary_RInf"
                %SIR_Model.SimAndPlot_Binary_RInf(Parameters);
                
            case "Binary_Special"
                SIR_Model.SimAndPlot_Binary_Special(Parameters);

            case "ODE"
                %SIR_Model.SimAndPlot_ODE(Parameters);
            case "ODE_RInf"
                %SIR_Model.SimAndPlot_ODE_RInf(Parameters);

            case "BinaryVsODE"
                %SIR_Model.SimAndPlot_BinaryVsODE(Parameters);    
            case "BinaryVsODE_RInf"
                %SIR_Model.SimAndPlot_BinaryVsODE_RInf(Parameters);

            case "BinaryVsODE_PointGraph"
                %SIR_Model.SimAndPlot_BinaryVsODE_PointGraph(Parameters);
                
            case 'Binary_ErrorChecking'
                %SIS_Model.Binary_ErrorChecking(Parameters);
        end
end



toc
