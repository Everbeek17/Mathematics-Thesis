function [numInfected, numSusceptible] = iterateNetwork_SIS(startingNodes, adjMatrix, ...
    numTimeSteps, infectionRate, recoveryRate)
%ITERATENETWORK_SIS Summary of this function goes here
%   Detailed explanation goes here

    N = length(startingNodes);
    currentNodes = startingNodes;
    numInfected = zeros(numTimeSteps + 1, 1);
    numSusceptible = zeros(numTimeSteps + 1, 1);
    
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
                    % if this node is connected to an infected node
                    if (adjMatrix(j,i) == 1 && (currentNodes(j) == Node.Infected))
                        numInfectedNeighbors = numInfectedNeighbors + 1;
                    end
                end
                
                if (numInfectedNeighbors > 0)
                    % try once, for each infected neighbor, to infect this node
                    for j = 1:numInfectedNeighbors
                        if (rand() <= infectionRate)
                            nextNodes(i) = Node.Infected;
                            break;
                        % if on last loop, then no more attempts to infect
                        elseif (j == numInfectedNeighbors)
                            nextNodes(i) = Node.Susceptible;
                        end
                    end
                else
                    % if no infected neighbors, stay susceptible
                    nextNodes(i) = Node.Susceptible;
                end
                
            % if the node is infected, will they become susceptible?    
            elseif (currentNodes(i) == Node.Infected)
                
                % if the given infected node recovers
                if (rand() <= recoveryRate)
                    nextNodes(i) = Node.Susceptible;
                else
                    % if failed recovery, stay infected
                    nextNodes(i) = Node.Infected;
                end
            end
        end
        
        % count and save number of infected and susceptible
        numInfected(timestep + 1) = sum(currentNodes(:) == Node.Infected);
        numSusceptible(timestep + 1) = sum(currentNodes(:) == Node.Susceptible);
        
        % update node array for next loop
        currentNodes = nextNodes;
    end
end

