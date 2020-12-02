function [] = SimAndPlot_BinaryVsODE(Parameters)
%SimAndPlot_SIS_BinaryVsODE Perform Binary vs ODE comparisons.
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
    
    % calculate ratios for each timestep
    ratioInfected_Binary = zeros(1, length(nodes));
    for i = 1:length(nodes)
        ratioInfected_Binary(i) = sum(nodes{i}(:) == Node.Infected)/...
            Parameters.N;
    end
    
    
    % Simulate ODE Model
    probabilities_ODE = SIS_Model.SimulateNetwork_ODE(initialNodes, ...
        adjacencyMatrix, Parameters.beta, ...
        Parameters.gamma, Parameters.length, Parameters.deltaT);
    
    % get the averages of all the ODE probabilites
    avgProbabilities_ODE = zeros(1, length(probabilities_ODE(:,1)));
    for i = 1:length(probabilities_ODE(:,1))
        avgProbabilities_ODE(i) = sum(probabilities_ODE(i,:))/Parameters.N;
    end
    
    
    %% Plot

    tiledlayout(2,2);
    
    % plot ODE figure
    ax1 = nexttile;
    plot(ax1, 0:Parameters.deltaT:Parameters.length, avgProbabilities_ODE, 'b');
    ylim([0,1]);
    title(ax1, "ODE Model");
    ylabel(ax1, "Probability a Node is Infected");
    xlabel(ax1, "Time");

    % plot Binary figure
    ax2 = nexttile;
    plot(ax2, 0:Parameters.deltaT:Parameters.length, ratioInfected_Binary, 'r');
    ylim([0,1]);
    title(ax2, "Binary Model");
    xlabel(ax2, "Time");
    ylabel(ax2, "Fraction of Nodes Infected");

    % plot ODE and Binary overlapping
    ax3 = nexttile([1 2]);
    plot(ax3, 0:Parameters.deltaT:Parameters.length, avgProbabilities_ODE, 'b');
    hold on
    plot(ax3, 0:Parameters.deltaT:Parameters.length, ratioInfected_Binary, 'r');
    ylim([0,1]);
    title(ax3, "Binary vs ODE Model");
    xlabel(ax3, "Time");
    ylabel(ax3, "Probability/Fraction of Nodes Infected");
    legend(ax3, "ODE", "Binary", "Location", "northwest");
    hold off

    % change fontsizes (make them bigger than default)
    ax1.FontSize = 16;
    ax2.FontSize = 16;
    ax3.FontSize = 16;
    
    if Parameters.saveFig
        % save figure
        dateTimeFormat = 'mm-dd-yy_HH:MM';
        figFileName = ['Figures/BinaryVsODE_', datestr(now,dateTimeFormat), '.fig'];
        savefig(figFileName);
    end
end

