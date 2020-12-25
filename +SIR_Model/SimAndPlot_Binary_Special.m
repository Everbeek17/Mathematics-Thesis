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
    numInfectedGroups = 4;
    
    
    
    
    % creates all initial infection values
    percentInitialInfected_values = percentInitialInfected_min:...
        percentInitialInfected_delta:...
        percentInitialInfected_max;
    

    %% Setup
    
    adjacencyMatrix = CreateAdjacencyMatrix(Parameters.N, Parameters.k);

    
    N = Parameters.N;
    
    
    % sort nodes by nodal degree
    sortedNodalDegreeMap = getSortedNodalDegreeMap(adjacencyMatrix);
    
    
    
    numPoints = length(percentInitialInfected_values) * numInfectedGroups;
    output = zeros(numPoints, 3);
    simulationCounter = 1;  % keeps track of which simulation we are on
    
    % to parallelize i need to change temp_counter to be calculated
    % independantly of each loop
    
    % iterate along each infection group within each infection group size
    for percentInitialInfected = percentInitialInfected_values
        
        % calculate number of individuals in each infected group
        groupSize = round(N * percentInitialInfected);
        
        %
        minX = 0 + groupSize/2;
        maxX = N - groupSize/2;
        
        % Y = some calculated variable needed below
        Y = (maxX - minX)/(numInfectedGroups - 1);
        
        % iterate over each group (each group being a different selection
        % of individuals from the initial adjacency matrix, the lowest 
        % group being the individuals with the lowest nodal degrees, and 
        % the highest group being the individuals with the highest nodal
        % degrees)
        for groupNum = 1:numInfectedGroups
            
            % X = index of array of individuals that is the center of
            % this group
            X = minX + (groupNum - 1)*Y;
            
            
            lowestInfectedIndividual = floor(X - groupSize/2);
            
            % TODO: find better solution for not being able to index 0
            if (lowestInfectedIndividual == 0)
                lowestInfectedIndividual = 1;
            end
            
            
            highestInfectedIndividual = lowestInfectedIndividual + groupSize;
            
            indices = lowestInfectedIndividual:1:highestInfectedIndividual;
            
            % get the indices to infect
            
            temp = sortedNodalDegreeMap(:,1);
            infect_indices = temp(indices);
            
            % and the nodal degrees of those indices
            temp = sortedNodalDegreeMap(:,2);
            nodal_degrees = temp(indices);
            
            
            
            
            % simulate
            
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

