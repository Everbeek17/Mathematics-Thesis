% Erkin Verbeek
% Professor Skardal


%{
    First, we create the same graph we created the very first time.
    Then we also create the matching ODE Graph.
        - Plots fraction of infected nodes for Binary (original) model
        - Plots averages of all nodes from ODE

%}


tic

%% Parameters

N = 2000;       % number of nodes
k = 5;          % mean degree (average nodal degree)
beta = 0.08;    % chance infected infects a neighbor
gamma = 0.07;   % chance infected becomes susceptible

simulationLength = 60;  % length of time to simulate
deltaT = 0.25;          % granularity of each time step

chanceOfInitialInfection = 0.03;    % chance a random node starts infected

%% Setup Binary Model

adjacencyMatrix = CreateAdjacencyMatrix(N, k);

initialNodes = CreateInitialNodes(chanceOfInitialInfection, N);

%% Iterate Binary Model

[numInfected, numSusceptible] = SimulateNetwork_SIS(initialNodes, ...
    adjacencyMatrix, beta, gamma, simulationLength, deltaT);







%% Plots

tiledlayout(2,1);
ax1 = nexttile;
plot(ax1, 0:deltaT:simulationLength, numInfected);
hold on
plot(ax1, 0:deltaT:simulationLength, numSusceptible);
title(ax1, 'Graph 1');
ylabel(ax1, 'Number of Individuals');
xlabel(ax1, 'Time');
legend(ax1, 'Infected', 'Susceptible');

ax2 = nexttile;
plot(ax2, 0:deltaT:simulationLength, numInfected/N);
title(ax2, 'Graph 2');
xlabel(ax2, 'Time');
ylabel(ax2, 'Fraction of Nodes Infected');

hold off

toc



