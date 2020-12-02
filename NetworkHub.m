%   Erkin Verbeek
%   Professor Skardal

tic

%% Decide the type of simulation to be run
modelType = "SIS";  % options: SIS, SIR
% options:  Binary, ODE, Binary_RInf, ODE_RInf,
% BinaryVsODE, BinaryVsODE_RInf, BinaryVsODE_PointGraph
simType = "BinaryVsODE_PointGraph";



%% Define simulation parameters

N = 200;       % Number of nodes
k = 8;          % Mean degree (average nodal degree)

simulationLength = 100;  % Length of time each simulation runs for
deltaT = 0.1;          % Granularity of each time step

initialInfectionChance = 0.02;    % chance a random node starts infected

beta = 0.06;    % Infection rate
gamma = 0.10;   % Recovery rate

saveFig = false;     % save .fig file to Figures folder?

% untilSteady-specific values (only used with untilSteady option)
if (strcmp(simType, 'Binary_RInf') || ...
        strcmp(simType, 'ODE_RInf') || ...
        strcmp(simType, 'BinaryVsODE_RInf'))
    
    
    % the range of beta values to consider (overwrites beta value above)
    betaValueMax = 0.06;
    betaValueMin = 0.0;
    deltaBeta = 0.0025;   % granularity between different beta values
end

% Move simulation parameter values to a single struct
Parameters = struct;
Parameters.simType = simType;
Parameters.modelType = modelType;
Parameters.N = N;
Parameters.k = k;
Parameters.beta = beta;
Parameters.gamma = gamma;
Parameters.length = simulationLength;
Parameters.deltaT = deltaT;
Parameters.saveFig = saveFig;
Parameters.initialInfectionChance = initialInfectionChance;
if (strcmp(simType, 'Binary_RInf') || ...
        strcmp(simType, 'ODE_RInf') || ...
        strcmp(simType, 'BinaryVsODE_RInf'))
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

            case "BinaryVsODE"
                SIS_Model.SimAndPlot_BinaryVsODE(Parameters);    
            case "BinaryVsODE_RInf"
                SIS_Model.SimAndPlot_BinaryVsODE_RInf(Parameters);

            case "BinaryVsODE_PointGraph"
                SIS_Model.SimAndPlot_BinaryVsODE_PointGraph(Parameters);
        end
        
        
    % SIR Model
    case "SIR"
        switch Parameters.simType
            case "Binary"
                SIS_Model.SimAndPlot_Binary(Parameters);
            case "Binary_RInf"
                SIS_Model.SimAndPlot_Binary_RInf(Parameters);

            case "ODE"
                SIS_Model.SimAndPlot_ODE(Parameters);
            case "ODE_RInf"
                SIS_Model.SimAndPlot_ODE_RInf(Parameters);

            case "BinaryVsODE"
                SIS_Model.SimAndPlot_BinaryVsODE(Parameters);    
            case "BinaryVsODE_RInf"
                SIS_Model.SimAndPlot_BinaryVsODE_RInf(Parameters);

            case "BinaryVsODE_PointGraph"
                SIS_Model.SimAndPlot_BinaryVsODE_PointGraph(Parameters);
        end
end



toc
