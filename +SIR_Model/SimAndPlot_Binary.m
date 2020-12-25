function [] = SimAndPlot_Binary(Parameters)
% Simulates and plots SIR model [Binary Method]
%   Simulates the SIR model using stochastic methods (each node is either
%   susceptible, infected, or recovered) and then plots results over time.

    %% Setup
    
    adjacencyMatrix = CreateAdjacencyMatrix(Parameters.N, Parameters.k);

    initialNodes = CreateInitialNodes(...
        Parameters.initialInfectionChance, Parameters.N);

    numTimeSteps = length(0:Parameters.deltaT:Parameters.length);
    
    %% Simulate

    nodes = SIR_Model.SimulateNetwork_Binary(...
        initialNodes, adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);
    
    % calculate totals for each timestep
    numSusceptible = zeros(1, numTimeSteps);
    numInfected = zeros(1, numTimeSteps);
    numRecovered = zeros(1, numTimeSteps);
    for i = 1:numTimeSteps
        numSusceptible(i) = sum(nodes{i}(:) == Node.Susceptible);
        numInfected(i) = sum(nodes{i}(:) == Node.Infected);
        numRecovered(i) = sum(nodes{i}(:) == Node.Recovered);
    end
    
    %% Plot

    plot(0:Parameters.deltaT:Parameters.length, numSusceptible);
    hold on
    plot(0:Parameters.deltaT:Parameters.length, numInfected);
    plot(0:Parameters.deltaT:Parameters.length, numRecovered);
    
    title('SIR Model Binary');
    ylabel('Number of Individuals');
    xlabel('Time');
    legend('Susceptible', 'Infected', 'Recovered');
    hold off
    
    if Parameters.saveFig
        SaveCurrentFigure(Parameters.modelType, Parameters.simType);
    end
end

