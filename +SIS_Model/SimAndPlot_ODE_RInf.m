function [] = SimAndPlot_ODE_RInf(Parameters)
% Simulates and plots SIS model [Binary Method]
%   Simulates the SIS model using ODE methods multiple times, and 
%   plots a graph of the beta values against the r_infinity values.

   %% Setup

    adjacencyMatrix = CreateAdjacencyMatrix(Parameters.N, Parameters.k);
    
    % declare local copies of values needed in each for loop to increase
    % efficiency when using parfor
    betaValues = Parameters.SteadyState.betaValues;
    initialInfectionChance = Parameters.initialInfectionChance;
    N = Parameters.N;
    gamma = Parameters.gamma;
    simLength = Parameters.length;
    deltaT = Parameters.deltaT;
    
    % array to save all the different r_inf values
    r_inf = zeros(1, length(betaValues));

    %% Simulate
    
    % perform a simulation for each beta value
    % [each simulation run in parallel since they are all independant]
    parfor i = 1:length(Parameters.SteadyState.betaValues)
        
        % create new beta and new initial nodes for each simulation
        beta = betaValues(i);
        initialNodes = CreateInitialNodes(...
            initialInfectionChance, N);
        
        % simulate
        probabilities = SIS_Model.SimulateNetwork_ODE(initialNodes, ...
            adjacencyMatrix, beta, gamma, ...
            simLength, deltaT);
        
        % get the average of all the last timestep ODE probabilites
        % aka the r_inf value for this simulation
        r_inf(i) = sum(probabilities(end,:))/N;
    end
    
    % calculate beta_c value corresponding to current setup
    beta_c = Parameters.gamma / max(eig(adjacencyMatrix));
    
    %% Plot

    % plot all r_Infinity values
    scatter(Parameters.SteadyState.betaValues, r_inf);
    ylim([0,1]);
    title('r_{\infty} values');
    % plot beta_c line on graph
    xline(beta_c, '-', '\beta_{c}');
    xlabel('\beta');
    ylabel('r_{\infty}');

    % change fontsize
    ax = gca;
    ax.FontSize = 16;

    if Parameters.saveFig
        % save figure
        dateTimeFormat = 'mm-dd-yy_HH:MM';
        figFileName = ['Figures/ODE_RInf_', datestr(now,dateTimeFormat), '.fig'];
        savefig(figFileName);
    end
end
