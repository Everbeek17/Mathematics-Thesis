function [] = SimAndPlot_BinaryVsODE_RInf(Parameters)
% Simulates and plots SIS to see r_inf values
%   Simulates the SIS model using both binary and ODE model

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
    
    % arrays to save all the different r_inf values
    r_inf_binary = zeros(1, length(betaValues));
    r_inf_ODE = zeros(1, length(betaValues));

    %% Simulate
    
    % perform a simulation for each beta value
    % [each simulation run in parallel since they are all independant]
    parfor i = 1:length(Parameters.SteadyState.betaValues)
        
        % create new beta and new initial nodes for each simulation
        beta = betaValues(i);
        initialNodes = CreateInitialNodes(...
            initialInfectionChance, N);
        
        
        
        % simulate Binary model
        nodes = SIS_Model.SimulateNetwork_Binary(initialNodes, ...
            adjacencyMatrix, beta, gamma, ...
            simLength, deltaT);
        
        % calculate average ratio of last 'value' timesteps 
        % TODO:
        % (very arbitrarily chosen value, should fix this later)
        % aka the r_inf value for this simulation
        value = 10;
        temp = 0;
        for j = 0:(value - 1)
            temp = temp + sum(nodes{end - j}(:) == Node.Infected)/N;
        end
        r_inf_binary(i) = temp / value;
        
        
        
        % simulate ODE model
        probabilities = SIS_Model.SimulateNetwork_ODE(initialNodes, ...
            adjacencyMatrix, beta, gamma, ...
            simLength, deltaT);
        
        % get the average of all the last timestep ODE probabilites
        % aka the r_inf value for this simulation
        r_inf_ODE(i) = sum(probabilities(end,:))/N;
        
        
    end
    
    % calculate beta_c value corresponding to current setup
    beta_c = Parameters.gamma / max(eig(adjacencyMatrix));
    
    %% Plot

    % plot all Binary and ODE r_Infinity values
    plot(Parameters.SteadyState.betaValues, r_inf_ODE);
    hold on
    scatter(Parameters.SteadyState.betaValues, r_inf_binary);
    hold off
    ylim([0,1]);
    title('r_{\infty} values');
    % plot beta_c line on graph
    xline(beta_c, '-', '\beta_{c}');
    legend("ODE", "Binary", "\beta_{c}","Location", "southeast");
    xlabel('\beta');
    ylabel('r_{\infty}');

    % Get handle to current axes.
    ax = gca;
    % change fontsizes
    ax.FontSize = 16;
    
    if Parameters.saveFig
        SaveCurrentFigure(Parameters.modelType, Parameters.simType);
    end
end
