function [probabilities] = SimulateNetwork_SIS_ODE(initialNodes, ...
    adjacencyMatrix, infectionRate, recoveryRate, simulationLength, deltaT)
%ITERATENETWORK_SIS Summary of this function goes here
%   returns the probabilities of EVERY node for EVERY timestep

    N = length(initialNodes);
    timeValues = 0:deltaT:simulationLength;
    numTimeSteps = length(timeValues);

    probabilities = zeros(numTimeSteps, 1);
    
    % Fill the initial probabilities (1 or 0 based on initial nodes)
    for i = 1:N
        probabilities(1, i) = initialNodes(i) == Node.Infected;
    end
    
    % iterate each timestep (skip 2 because 1 is initial conditions)
    for timestep = 2:numTimeSteps
        
        % calculate the next probabilites for each node
        probabilities(timestep, :) = SIS_IncrementNodes_ODE(...
            probabilities(timestep-1,:), adjacencyMatrix, infectionRate, ...
            recoveryRate, deltaT);

    end
end
