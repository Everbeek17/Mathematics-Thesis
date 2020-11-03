% Erkin Verbeek
% Professor Skardal

%{
    We want to perform a lot of different SIS simulations using different
    Beta values and calculate the R_Infinity value for each one.

    We will then plot those R_Infinity values versus Beta values and look
    for a value of Beta where the R_Infinity values go from zero to
    non-zero. (for what Beta values does the disease stay alive).
%}

tic

%% Parameters

N = 2000;       % number of nodes
k = 5;          % mean degree (average nodal degree)
gamma = 0.20;   % chance infected becomes susceptible

chanceOfInitialInfection = 0.03;    % chance a random node starts infected

% minimum length of time a simluation will run for before starting to look
% for a steady-state behaviour
minSimulationLength = 50;   
deltaT = 0.50;              % granularity of each time step

% the range of beta values to consider
betaValueMax = 0.10;
betaValueMin = 0.0;
deltaBeta = 0.0025;   % granularity between different beta values
betaValues = betaValueMin:deltaBeta:betaValueMax;

% Values used to determine once we've hit the steady state
steadyStateWiggleRoom = 0.03;   % the range in percentage
steadyStateSeconds = 10;        % how many seconds 
% once the last _ seconds worth of values all fall within the _ range: 
% we've hit the steady state.
%% Simulate

% create array to save r_Infinity values for each simulation
r_Infinity = zeros(length(betaValues), 1);

% array to save seconds elapsed for each steady state simulation
secondsElapsed = zeros(length(betaValues), 1);

% use same adjacency matrix for each simulation
adjacencyMatrix = CreateAdjacencyMatrix(N, k);

% iterate over each beta value
% (skipping beta = 0)
for i = 2:length(betaValues)
    
    % setup each simulation
    beta = betaValues(i);
    initialNodes = CreateInitialNodes(chanceOfInitialInfection, N);
    
    % iterate simulation until it reaches a steady state
    [r_Infinity(i), secondsElapsed(i)] = SimulateNetwork_SIS_UntilSteadyState(...
        initialNodes, adjacencyMatrix, beta, gamma, minSimulationLength, ...
        deltaT, steadyStateWiggleRoom, steadyStateSeconds);
end

% calculate beta_c value corresponding to current setup
beta_c = gamma / max(eig(adjacencyMatrix))


%% Plot

tiledlayout(2,1);
ax1 = nexttile;
% plot all r_Infinity values
scatter(ax1, betaValues, r_Infinity);
hold on
title(ax1, 'r_{\infty} values');
% plot beta_c line on graph
xline(ax1, beta_c, '-', '\beta_{c}');
xlabel(ax1, '\beta');
ylabel(ax1, 'r_{\infty}');

ax2 = nexttile;
plot(ax2, betaValues, secondsElapsed);
title(ax2, 'Seconds Until Steady State Achieved');
xlabel(ax2, '\beta');
ylabel(ax2, 'Seconds');

% change fontsizes
ax1.FontSize = 16;
ax2.FontSize = 16;

hold off

% save figure
dateTimeFormat = 'mm-dd-yy_HH:MM';
figFileName = ['Beta_c_', datestr(now,dateTimeFormat), '.fig'];
savefig(figFileName);

toc
