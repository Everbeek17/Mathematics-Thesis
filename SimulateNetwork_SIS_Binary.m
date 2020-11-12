function [nodes] = SimulateNetwork_SIS_Binary(...
    initialNodes, adjacencyMatrix, infectionRate, recoveryRate, ...
    simulationLength, deltaT)
% Simulates network using SIS model and Binary states.
%   Detailed explanation goes here

    timeValues = 0:deltaT:simulationLength;
    numTimeSteps = length(timeValues);
    
    % initialize cell array that records nodes for each timestep
    nodes = cell(1, numTimeSteps);
    % set first timestep as initial nodes
    nodes{1} = initialNodes;

    % start at 2 to skip over t = 0 (the "first" time step, 
    % which is saved above before we start incrementing)
    for timestep = 2:numTimeSteps
        
        % calculate next nodes
        nodes{timestep} = SIS_IncrementNodes_Binary(...
            nodes{timestep-1}, adjacencyMatrix, infectionRate, ...
            recoveryRate, deltaT);
        
    end
end
