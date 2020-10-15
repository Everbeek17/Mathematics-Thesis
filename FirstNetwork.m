% Erkin Verbeek
% Professor Skardal

tic

%% Parameters

N = 5000;      % number of nodes
k = 5;          % mean degree (average nodal degree)
beta = 0.08;     % chance infected infects a neighbor
gamma = 0.08;   % chance infected becomes susceptible

chanceOfInitialInfection = 0.02;    % chance a random node starts infected
numTimeSteps = 50;

%% Setup

adjacencyMatrix = CreateAdjacencyMatrix(N, k);

initialNodes = CreateInitialNodes(chanceOfInitialInfection, N);

%% Iterate

[numInfected, numSusceptible] = iterateNetwork_SIS(initialNodes, ...
    adjacencyMatrix, numTimeSteps, beta, gamma);

%% Plots

plot(0:numTimeSteps, numInfected);
hold on
plot(0:numTimeSteps, numSusceptible);
hold off


toc




