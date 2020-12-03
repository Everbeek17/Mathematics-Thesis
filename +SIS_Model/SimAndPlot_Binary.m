function [] = SimAndPlot_Binary(Parameters)
% Simulates and plots SIS model [Binary Method]
%   Simulates the SIS model using binary methods (each node is either
%   infected or not) and then plots results over time.

    %% Setup
    
    adjacencyMatrix = CreateAdjacencyMatrix(Parameters.N, Parameters.k);

    initialNodes = CreateInitialNodes(...
        Parameters.initialInfectionChance, Parameters.N);

    %% Simulate

    nodes = SIS_Model.SimulateNetwork_Binary(...
        initialNodes, adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);

    % calculate totals for each timestep
    numTimeSteps = length(0:Parameters.deltaT:Parameters.length);
    numInfected = zeros(1, numTimeSteps);
    numSusceptible = zeros(1, numTimeSteps);
    for i = 1:numTimeSteps
        numInfected(i) = sum(nodes{i}(:) == Node.Infected);
        numSusceptible(i) = sum(nodes{i}(:) == Node.Susceptible);
    end
    
    %% Plot

    tiledlayout(2,1);
    ax1 = nexttile;
    plot(ax1, 0:Parameters.deltaT:Parameters.length, numInfected);
    hold on
    plot(ax1, 0:Parameters.deltaT:Parameters.length, numSusceptible);
    title(ax1, 'Graph 1');
    ylabel(ax1, 'Number of Individuals');
    xlabel(ax1, 'Time');
    legend(ax1, 'Infected', 'Susceptible');

    ax2 = nexttile;
    plot(ax2, 0:Parameters.deltaT:Parameters.length, numInfected/Parameters.N);
    title(ax2, 'Graph 2');
    xlabel(ax2, 'Time');
    ylabel(ax2, 'Fraction of Nodes Infected');

    hold off
    
    if Parameters.saveFig
        SaveCurrentFigure(Parameters.modelType, Parameters.simType);
    end
end

