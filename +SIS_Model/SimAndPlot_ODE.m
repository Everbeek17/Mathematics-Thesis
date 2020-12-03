function [] = SimAndPlot_ODE(Parameters)
% Simulates and plots SIS model [ODE Method]
%   Simulates the SIS model using ODE methods (each node has a probability
%   of being infected at any given time) and then plots results over time.


    %% Setup

    adjacencyMatrix = CreateAdjacencyMatrix(Parameters.N, Parameters.k);

    initialNodes = CreateInitialNodes(...
        Parameters.initialInfectionChance, Parameters.N);

    %% Simulate

    probabilities_ODE = SIS_Model.SimulateNetwork_ODE(initialNodes, ...
        adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);
    
    % get the averages of all the ODE probabilites
    avgProbabilities = zeros(1, length(probabilities_ODE(:,1)));
    for i = 1:length(probabilities_ODE(:,1))
        avgProbabilities(i) = sum(probabilities_ODE(i,:))/Parameters.N;
    end
    
    %% Plot

    plot(0:Parameters.deltaT:Parameters.length, avgProbabilities);
    title("ODE");
    ylim([0,1]);
    xlabel("Time");
    ylabel("Probability a Node is Infected");

    if Parameters.saveFig
        SaveCurrentFigure(Parameters.modelType, Parameters.simType);
    end
end

