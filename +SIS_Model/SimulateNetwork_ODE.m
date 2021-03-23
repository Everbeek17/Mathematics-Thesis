function [probabilities] = SimulateNetwork_ODE(initialNodes, adjacencyMatrix, infectionRate, recoveryRate, simulationLength, deltaT, optional_startingProbabilities)
%Simulates network using SIS model and an ODE equation for probabilites.
%   Returns a 2D array of the calculated probabilities of every node at 
%   every timestep.

    N = length(initialNodes);
    timeValues = 0:deltaT:simulationLength;
    numTimeSteps = length(timeValues);

    % allocate return array
    probabilities = zeros(numTimeSteps, N);
    
    % check for optional input arg
    if (nargin < 7) 
        % Fill the initial probabilities (1 or 0 based on initial nodes)
        for i = 1:N
            probabilities(1, i) = initialNodes(i) == Node.Infected;
        end
    elseif (nargin == 7)
        probabilities(1, :) = optional_startingProbabilities;
    end
    
    % iterate each timestep (skip t = 2 because t = 1 is initial condition)
    for timestep = 2:numTimeSteps
        
        % calculate the next probabilites for each node
        probabilities(timestep, :) = SIS_Model.IncrementNodes_ODE(...
            probabilities(timestep-1,:), adjacencyMatrix, infectionRate, ...
            recoveryRate, deltaT);

    end
end
