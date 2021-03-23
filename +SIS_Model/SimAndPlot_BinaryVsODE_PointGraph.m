function [] = SimAndPlot_BinaryVsODE_PointGraph(Parameters)
%SimAndPlot_SIS_BinaryVsODE_PointGraph Perform Binary vs ODE comparison.
%   Simulate both the Binary model and the ODE model then plot them
%   together on the same graph to allow for comparison.


    %% Setup

    N = Parameters.N;
    
    adjacencyMatrix = CreateAdjacencyMatrix(N, Parameters.k);

    initialNodes = CreateInitialNodes(...
        Parameters.initialInfectionChance, N);
    
    steadyStateTimeStep = Parameters.cutOffTime;

    %% Simulate

    % simulate Binary model
    nodes = SIS_Model.SimulateNetwork_Binary(...
        initialNodes, adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);
    
    % Simulate ODE Model
    probabilities_ODE = SIS_Model.SimulateNetwork_ODE(initialNodes, ...
        adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);
    
    %% Post-processing
    
    % calculate average time spent infected for each node in Binary sim
    % only starting from steadyStateTimeStep and onwards
    ratioSpentInfected_Binary = zeros(N, 1);
    for node_i = 1:N
        total = 0;
        for timestep = ...
                steadyStateTimeStep : length(nodes)
            total = total + (nodes{timestep, 1}(1, node_i) == Node.Infected);
        end
        ratioSpentInfected_Binary(node_i) = total/...
            (length(nodes) + 1 - steadyStateTimeStep);
    end
    
    % get the final ODE probabilities for each node
    finalProbabilities_ODE = zeros(N, 1);
    for i = 1:N
        finalProbabilities_ODE(i) = probabilities_ODE(end, i);
    end
    
    % get nodal degree for all nodes
    nodal_degree = getNodalDegrees(adjacencyMatrix);
    max_degree = max(nodal_degree);
    
    color_gradient = cell(max_degree, 1);
    
    for i = 1:max_degree + 1
        color_gradient{i} = [0 + (i-1)/max_degree 1 - (i-1)/max_degree 0];
    end
    
    %% Plot
    
    % plot combined figure
    close all
    hold on
    for i = 1:N
        scatter(finalProbabilities_ODE(i), ...
            ratioSpentInfected_Binary(i), 'MarkerEdgeColor', ...
            color_gradient{nodal_degree(i)});
    end
    hold off
    
%    annotation('textbox', [0.15, 0.8, 0.2, 0.1], ...
%        'String', "Green = smaller nodal degree");
%    annotation('textbox', [0.15, 0.7, 0.2, 0.1], ...
%        'String', "Red = higher nodal degree");
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

