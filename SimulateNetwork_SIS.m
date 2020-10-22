function [numInfected, numSusceptible] = SimulateNetwork_SIS(initialNodes, ...
    adjMatrix, infectionRate, recoveryRate, simulationLength, deltaT)
%ITERATENETWORK_SIS Summary of this function goes here
%   Detailed explanation goes here


    timeValues = 0:deltaT:simulationLength;
    numTimeSteps = length(timeValues);
    N = length(initialNodes);
    
    % initialize arrays that record sums as network progresses through time
    numInfected = zeros(numTimeSteps, 1);
    numSusceptible = zeros(numTimeSteps, 1);
    
    currentNodes = initialNodes;
    
    % calulate this once at the beginning, and then again after each loop
    numInfected(1) = sum(currentNodes(:) == Node.Infected);
    numSusceptible(1) = sum(currentNodes(:) == Node.Susceptible);
    
    for timestep = 1:numTimeSteps
        
        % initialize next iteration's array
        nextNodes = Node.empty(N, 0);
        
        % this would work in parfor
        % iterate along every node
        for i = 1:N
            
            % if the node is susceptible, will they become infected?
            if (currentNodes(i) == Node.Susceptible)
                
                % count how many of the neighbors are infected
                numInfectedNeighbors = 0;
                for j = 1:N
                    % if another infected node is connected to this node
                    if (adjMatrix(j,i) == 1 && (currentNodes(j) == Node.Infected))
                        numInfectedNeighbors = numInfectedNeighbors + 1;
                    end
                end
                
                % default node to susceptible, then see if it gets infected
                nextNodes(i) = Node.Susceptible;
                % try once, for each infected neighbor, to infect this node
                for j = 1:numInfectedNeighbors
                    if (rand() <= (infectionRate * deltaT))
                        nextNodes(i) = Node.Infected;
                        break;
                    end
                end
  
            % if the node is infected, will they become susceptible?    
            elseif (currentNodes(i) == Node.Infected)
                
                % if the given infected node recovers
                if (rand() <= (recoveryRate * deltaT))
                    nextNodes(i) = Node.Susceptible;
                % if failed recovery, stay infected
                else
                    nextNodes(i) = Node.Infected;
                end
            end
        end
        
        % count and save number of infected and susceptible
        numInfected(timestep) = sum(currentNodes(:) == Node.Infected);
        numSusceptible(timestep) = sum(currentNodes(:) == Node.Susceptible);
        
        % update node array for next loop
        currentNodes = nextNodes;
    end
end
