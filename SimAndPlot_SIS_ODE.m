function [] = SimAndPlot_SIS_ODE(Parameters)
% Simulates and plots SIS model [ODE Method]
%   Simulates the SIS model using ODE methods (each node has a probability
%   of being infected at any given time) and then plots results over time.


    %% Setup

    adjacencyMatrix = CreateAdjacencyMatrix(Parameters.N, Parameters.k);

    initialNodes = CreateInitialNodes(...
        Parameters.initialInfectionChance, Parameters.N);

    %% Simulate

    avgProbabilities = SimulateNetwork_SIS_ODE(initialNodes, ...
        adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);

    %% Plot

    plot(0:Parameters.deltaT:Parameters.length, avgProbabilities);
    title("ODE");
    ylim([0,1]);
    xlabel("Time");
    ylabel("Probability a Node is Infected");


end

