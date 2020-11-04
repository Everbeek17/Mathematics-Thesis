%   Erkin Verbeek
%   Professor Skardal

tic

%% Decide the type of simulation to be run
% options:  SIS_Binary, SIS_ODE, SIS_untilSteady, SIS_ODE_vs_Binary
simType = "SIS_ODE_vs_Binary";



%% Define simulation parameters

N = 1000;       % Number of nodes
k = 5;          % Mean degree (average nodal degree)

simulationLength = 70;  % Length of time each simulation runs for
deltaT = 0.10;          % Granularity of each time step

initialInfectionChance = 0.02;    % chance a random node starts infected

beta = 0.06;    % Infection rate
gamma = 0.08;   % Recovery rate


% untilSteady-specific values (only used with untilSteady option)
if (strcmp(simType, 'SIS_untilSteady'))
    
    minSimulationLength = simulationLength;     % min length to simulate
    maxSimulationLength = simulationLength*2;   % max length to simulate

    % the range of beta values to consider (overwrites beta value above)
    betaValueMax = 0.10;
    betaValueMin = 0.0;
    deltaBeta = 0.0025;   % granularity between different beta values

    % Values used to determine once we've hit the steady state
    steadyStatewiggleRange = 0.03;  % the range in percentage
    steadyStatewiggleSeconds = 10;  % how many seconds 
    % once the last _ seconds worth of values all fall within the _ range: 
    % we've hit the steady state.
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
Parameters.initialInfectionChance = initialInfectionChance;
if (strcmp(simType, 'SIS_untilSteady'))
    Parameters.SteadyState.minLength = minSimulationLength;
    Parameters.SteadyState.maxLength = maxSimulationLength;
    Parameters.SteadyState.betaValues = betaValueMin:deltaBeta:betaValueMax;
    Parameters.SteadyState.deltaBeta = deltaBeta;
    Parameters.SteadyState.wiggleRange = steadyStatewiggleRange;
    Parameters.SteadyState.wiggleSeconds = steadyStatewiggleSeconds;
end

% removes unecessary duplicate variables
clearvars("-except", "Parameters");

%% Call specific functions depending on the simulation choice

switch Parameters.simType
    case "SIS_Binary"
        SimAndPlot_SIS_Binary(Parameters);
    case "SIS_untilSteady"
        
    case "SIS_ODE"
        SimAndPlot_SIS_ODE(Parameters);
    case "SIS_ODE_vs_Binary"
        SimAndPlot_SIS_BinaryVsODE(Parameters);
        
end


toc
