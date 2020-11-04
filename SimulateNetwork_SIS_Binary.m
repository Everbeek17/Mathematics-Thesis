function [numInfected, numSusceptible] = SimulateNetwork_SIS_Binary(...
    initialNodes, adjacencyMatrix, infectionRate, recoveryRate, ...
    simulationLength, deltaT)
% Simulates network using SIS model and Binary states.
%   Detailed explanation goes here

    timeValues = 0:deltaT:simulationLength;
    numTimeSteps = length(timeValues);
    
    % initialize arrays that record sums as network progresses through time
    numInfected = zeros(numTimeSteps, 1);
    numSusceptible = zeros(numTimeSteps, 1);
    
    currentNodes = initialNodes;
    
    % calulate this once at the beginning, and then again after each loop
    numInfected(1) = sum(currentNodes(:) == Node.Infected);
    numSusceptible(1) = sum(currentNodes(:) == Node.Susceptible);
    
    % start at 2 to skip over t = 0 (the "first" time step, 
    % which is saved above as the sum before we start incrementing)
    for timestep = 2:numTimeSteps
        
        % increment nodes
        currentNodes = SIS_IncrementNodes_Binary(currentNodes, ...
            adjacencyMatrix, infectionRate, recoveryRate, deltaT);
        
        % count and save number of infected and susceptible
        numInfected(timestep) = sum(currentNodes(:) == Node.Infected);
        numSusceptible(timestep) = sum(currentNodes(:) == Node.Susceptible);
    end
end
