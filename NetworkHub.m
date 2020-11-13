%   Erkin Verbeek
%   Professor Skardal

tic

%% Decide the type of simulation to be run
% options:  SIS_Binary, SIS_ODE, SIS_Binary_RInf, SIS_ODE_RInf,
% SIS_BinaryVsODE, SIS_BinaryVsODE_RInf, SIS_BinaryVsODE_PointGraph
simType = "SIS_BinaryVsODE_PointGraph";



%% Define simulation parameters

N = 1000;       % Number of nodes
k = 8;          % Mean degree (average nodal degree)

simulationLength = 100;  % Length of time each simulation runs for
deltaT = 0.1;          % Granularity of each time step

initialInfectionChance = 0.02;    % chance a random node starts infected

beta = 0.06;    % Infection rate
gamma = 0.10;   % Recovery rate

saveFig = false;     % save .fig file to Figures folder?

% untilSteady-specific values (only used with untilSteady option)
if (strcmp(simType, 'SIS_Binary_RInf') || ...
        strcmp(simType, 'SIS_ODE_RInf') || ...
        strcmp(simType, 'SIS_BinaryVsODE_RInf'))
    
    
    % the range of beta values to consider (overwrites beta value above)
    betaValueMax = 0.06;
    betaValueMin = 0.0;
    deltaBeta = 0.0025;   % granularity between different beta values
end

% Move simulation parameter values to a single struct
Parameters = struct;
Parameters.simType = simType;
Parameters.N = N;
Parameters.k = k;
Parameters.beta = beta;
Parameters.gamma = gamma;
Parameters.length = simulationLength;
Parameters.deltaT = deltaT;
Parameters.saveFig = saveFig;
Parameters.initialInfectionChance = initialInfectionChance;
if (strcmp(simType, 'SIS_Binary_RInf') || ...
        strcmp(simType, 'SIS_ODE_RInf') || ...
        strcmp(simType, 'SIS_BinaryVsODE_RInf'))
    Parameters.beta = [];
    Parameters.SteadyState.betaValues = betaValueMin:deltaBeta:betaValueMax;
    Parameters.SteadyState.deltaBeta = deltaBeta;
end

% removes unecessary duplicate variables
clearvars("-except", "Parameters");

%% Call specific functions depending on the simulation choice

switch Parameters.simType
    case "SIS_Binary"
        SimAndPlot_SIS_Binary(Parameters);
    case "SIS_Binary_RInf"
        SimAndPlot_SIS_Binary_RInf(Parameters);
    
    case "SIS_ODE"
        SimAndPlot_SIS_ODE(Parameters);
    case "SIS_ODE_RInf"
        SimAndPlot_SIS_ODE_RInf(Parameters);
        
    case "SIS_BinaryVsODE"
        SimAndPlot_SIS_BinaryVsODE(Parameters);    
    case "SIS_BinaryVsODE_RInf"
        SimAndPlot_SIS_BinaryVsODE_RInf(Parameters);

    case "SIS_BinaryVsODE_PointGraph"
        SimAndPlot_SIS_BinaryVsODE_PointGraph(Parameters);
end


toc
