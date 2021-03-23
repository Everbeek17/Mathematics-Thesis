function [] = SimAndPlot_Binary_Special(Parameters)
% Simulates and plots special metrics from repeated SIR model simulations
% [using stochastic model]
%   Simulates the SIR model using stochastic methods (each node is either
%   susceptible, infected, or recovered) multiple times, using different
%   simulation conditions for each, saving special metrics from each 
%   simulation, and then plotting the results for the different inputs.
%   NOTE: a lot of this was thrown together hastily because I was focusing
%   most of my attention on completing grad school apps, but I'll come back
%   later and clean this up eventually I promise.

    %% Parameters

    % define ranges of initial infection values to iterate over
    percentInitialInfected_min = 0.02;  % min value
    percentInitialInfected_max = 0.20;  % max value
    percentInitialInfected_delta = 0.02;    % delta value
    
    % define number of groups to "chunk" the initial nodes into
    numInfectedGroups = 5;
    
    N = Parameters.N;
    
    % how many different metrics we are looking at per simulation
    numMetrics = 4;
    
    %% Setup
    
    % creates all initial infection values
    percentInitialInfected_values = percentInitialInfected_min:...
        percentInitialInfected_delta:...
        percentInitialInfected_max;
    
    
    adjacencyMatrix = CreateAdjacencyMatrix(N, Parameters.k);
    
    
    % sort nodes by nodal degree
    % creates N x 2 array, first column being the node index, and the
    % second column being the nodal degree of that node.
    sortedNodalDegreeMap = getSortedNodalDegreeMap(adjacencyMatrix);
    
    
    
    numSimulations = length(percentInitialInfected_values) * numInfectedGroups;
    output = zeros(numSimulations, numMetrics);
    simulationCounter = 1;  % keeps track of which simulation we are on
    
    % to parallelize i need to change simulationCounter to be calculated
    % independantly of each loop
    
    % iterate along each infection group within each infection group size
    for percentInitialInfected = percentInitialInfected_values
        
        % calculate number of individuals in each infected group
        % this group size is decided by the initial infection chance
        initialInfectedGroupSize = round(N * percentInitialInfected);
        
        % ? center indices of lowest and highest groups ?
        % 1 to N being full range, with "initialInfectedGroupSize" of
        % groups equally spaced out within it, with the lowest and highest
        % groups pressing up all the way against the ends (1 and N).
        % These variables are the lowest group's center and the
        % highest group's center.
        minCenter = (1 + initialInfectedGroupSize)/2;
        maxCenter = N - (initialInfectedGroupSize - 1)/2;
        
        % Y = some calculated variable used below
        Y = (maxCenter - minCenter)/(numInfectedGroups - 1);
        
        % iterate over each group (each group being a different selection
        % of individuals from the initial adjacency matrix, the lowest 
        % group being the individuals with the lowest nodal degrees, and 
        % the highest group being the individuals with the highest nodal
        % degrees)
        for groupNum = 1:numInfectedGroups
            
            % X = index of array of individuals that is the center of
            % this group
            X = minCenter + (groupNum - 1)*Y;
            
            
            lowestInfectedIndividual = ...
                floor(X - (initialInfectedGroupSize - 1)/2);

            highestInfectedIndividual = lowestInfectedIndividual + ...
                (initialInfectedGroupSize - 1);
            
            % there should be exactly "groupNum" of indices chosen
            indices = ...
                lowestInfectedIndividual:1:highestInfectedIndividual;
            
            
            
            
            % continue from here
            
            
            
            
            % get the indices to infect
            
            % get just the indices of the nodes that we have chosen
            % earlier, (they were chosen based on their nodal degrees
            % relative to the rest) as calculated further above.
            infect_indices = sortedNodalDegreeMap(indices, 1);
            
            
            % Same as above but grabbing the nodal degrees instead
            nodal_degrees = sortedNodalDegreeMap(indices, 2);
            
            
            
            
            %% simulate
            
            % infect the nodes at the calculated indices
            % TODO: move to its own function?
            initialNodes = Node.empty(N, 0);
            for i = 1:N
                if (ismember(i, infect_indices))
                    initialNodes(i) = Node.Infected;
                else
                    initialNodes(i) = Node.Susceptible;
                end
            end
            
            
            
            
            
            
            
            
            numTimeSteps = length(0:Parameters.deltaT:Parameters.length);

            nodes = SIR_Model.SimulateNetwork_Binary(...
                initialNodes, adjacencyMatrix, Parameters.beta, ...
                Parameters.gamma, Parameters.length, Parameters.deltaT);

            % calculate s_infinity (number of susceptible at end of
            % simulation)
            S_Inf = sum(nodes{numTimeSteps}(:) == Node.Susceptible);
            
            % calculate I_Max
            numInfected = zeros(1, numTimeSteps);
            for i = 1:numTimeSteps
                numInfected(i) = sum(nodes{i}(:) == Node.Infected);
            end
            
            % Save values to "output" array for plotting
            
            % infection chance
            output(simulationCounter, 1) = percentInitialInfected;
            % avg nodal degree
            output(simulationCounter, 2) = mean(nodal_degrees);
            % S_Inf
            output(simulationCounter, 3) = S_Inf;
            % I_Max
            output(simulationCounter, 4) = max(numInfected);
            
            simulationCounter = simulationCounter + 1;
        end
    end
    
    
    %% plot
    %plot3(output(:, 1), output(:, 2), output(:, 3));
    %surf(output(:, 1), output(:, 2), output(:, 3));
    
    % Plotting scheme taken from the internet: 
    % https://www.mathworks.com/matlabcentral/answers/387362-how-do-i-create-a-3-dimensional-surface-from-x-y-z-points
    x = output(:, 1);
    y = output(:, 2);
    z = output(:, 3);
    
    figure(1)
    stem3(x, y, z)
    grid on
    
    xv = linspace(min(x), max(x), 20);
    yv = linspace(min(y), max(y), 20);
    [X,Y] = meshgrid(xv, yv);
    Z = griddata(x,y,z,X,Y);
    
    figure(2)
    surf(X, Y, Z);
    
    xlabel("% Initial Infected");
    ylabel("Average Nodal Degree");
    zlabel("S Infinity Value");
    
    grid on
    %set(gca, 'ZLim',[0 100])
    shading interp
    
    z = output(:, 4);
    
    figure(3)
    stem3(x, y, z)
    
    grid on
    
    xv = linspace(min(x), max(x), 20);
    yv = linspace(min(y), max(y), 20);
    [X,Y] = meshgrid(xv, yv);
    Z = griddata(x,y,z,X,Y);
    
    figure(4)
    surf(X, Y, Z);
    
    xlabel("% Initial Infected");
    ylabel("Average Nodal Degree");
    zlabel("Infected Max Values");
    
    grid on
    %set(gca, 'ZLim',[0 100])
    shading interp
    
    if Parameters.saveFig
        SaveCurrentFigure(Parameters.modelType, Parameters.simType);
    end
end

