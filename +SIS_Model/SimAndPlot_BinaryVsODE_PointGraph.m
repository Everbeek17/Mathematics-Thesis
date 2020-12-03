function [] = SimAndPlot_BinaryVsODE_PointGraph(Parameters)
%SimAndPlot_SIS_BinaryVsODE_PointGraph Perform Binary vs ODE comparison.
%   Simulate both the Binary model and the ODE model then plot them
%   together on the same graph to allow for comparison.


    %% Setup

    adjacencyMatrix = CreateAdjacencyMatrix(Parameters.N, Parameters.k);

    initialNodes = CreateInitialNodes(...
        Parameters.initialInfectionChance, Parameters.N);

    %% Simulate

    % Simulate Binary model
    nodes = SIS_Model.SimulateNetwork_Binary(...
        initialNodes, adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);
    
    % calculate average time spent infected for each node
    % over second half of all timesteps
    ratioSpentInfected_Binary = zeros(1, length(nodes{1}));
    for node_i = 1:length(nodes{1})
        total = 0;
        for timestep = 1:length(nodes)
            total = total + (nodes{timestep}(node_i) == Node.Infected);
        end
        ratioSpentInfected_Binary(node_i) = total/length(nodes);
    end
    
    
    
    % Simulate ODE Model
    probabilities_ODE = SIS_Model.SimulateNetwork_ODE(initialNodes, ...
        adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);
    
    % get the final probabilities for each node
    finalProbabilities_ODE(:) = probabilities_ODE(end,:);
    
    
    %% Plot
    
    % plot combined figure
    scatter(finalProbabilities_ODE, ratioSpentInfected_Binary);
    ylim([0,1]);
    xlim([0,1]);
    title("Individual Nodes [Binary vs ODE]");
    ylabel("Fraction of time spent infected [Binary]");
    xlabel("Final probability of infection [ODE]");

    ax = gca;

    % change fontsizes (make them bigger than default)
    ax.FontSize = 16;
    
    if Parameters.saveFig
        SaveCurrentFigure(Parameters.modelType, Parameters.simType);
    end
end

