function [nodes] = SimulateNetwork_Binary(initialNodes, adjacencyMatrix, infectionRate, recoveryRate, simulationLength, deltaT)
%Simulates network using SIS model and Binary states.
%   Returns a cell array of the state of all the nodes at every time step.

    timeValues = 0:deltaT:simulationLength;
    numTimeSteps = length(timeValues);
    
    % initialize cell array that records nodes at each timestep
    nodes = cell(numTimeSteps, 1);
    % initialize array that keeps track of how many nodes are susceptible
    numSusceptible = zeros(numTimeSteps, 1);
    % set first timestep as initial nodes
    nodes{1} = initialNodes;

    % start at t = 2 to skip over t = 1 (the "first" time step, 
    % which is saved above before we start incrementing)
    for timestep = 2:numTimeSteps
        
        % calculate next nodes
        nodes{timestep} = SIS_Model.IncrementNodes_Binary(...
            nodes{timestep-1}, adjacencyMatrix, infectionRate, ...
            recoveryRate, deltaT);

        % sum up number of currently susceptible nodes
        numSusceptible(timestep) = sum(nodes{timestep}(:) == Node.Susceptible);
    end
end
