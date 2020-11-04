function [] = SimAndPlot_SIS_Binary(Parameters)
% Simulates and plots SIS model [Binary Method]
%   Simulates the SIS model using binary methods (each node is either
%   infected or not) and then plots results over time.

    %% Setup

    adjacencyMatrix = CreateAdjacencyMatrix(Parameters.N, Parameters.k);

    initialNodes = CreateInitialNodes(...
        Parameters.initialInfectionChance, Parameters.N);

    %% Simulate

    [numInfected, numSusceptible] = SimulateNetwork_SIS_Binary(...
        initialNodes, adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);

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

end

