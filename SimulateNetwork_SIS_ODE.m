function [avgProbabilities] = SimulateNetwork_SIS_ODE(initialNodes, ...
    adjacencyMatrix, infectionRate, recoveryRate, simulationLength, deltaT)
%ITERATENETWORK_SIS Summary of this function goes here
%   Detailed explanation goes here

    N = length(initialNodes);
    timeValues = 0:deltaT:simulationLength;
    numTimeSteps = length(timeValues);

    avgProbabilities = zeros(1, numTimeSteps);
    
    % create the initial probabilities (1 or 0 based on initial nodes)
    currentProbabilities = zeros(1, length(initialNodes));
    for i = 1:N
        currentProbabilities(i) = initialNodes(i) == Node.Infected;
    end
    
    % calculate average probabilites for initial start
    avgProbabilities(1) = sum(currentProbabilities(:))/N;

    % iterate each timestep (skip 2 because 2 is initial conditions)
    for timestep = 2:numTimeSteps
        
        % increment probabilities per node
        currentProbabilities = SIS_IncrementNodes_ODE(...
            currentProbabilities, adjacencyMatrix, infectionRate, ...
            recoveryRate, deltaT);
        
        % calculate average probability for each time step
        avgProbabilities(timestep) = sum(currentProbabilities(:))/N;

    end
end
