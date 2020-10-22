function [nextNodes] = SIS_IncrementNodes(currentNodes, ...
    adjacencyMatrix, infectionRate, recoveryRate, deltaT)
%SIS_INCREMENT Summary of this function goes here
%   Detailed explanation goes here


    N = length(currentNodes);
    
    % create next iteration, defaulting all nodes to susceptible
    nextNodes = Node.empty(N, 0);
    nextNodes(1:N) = Node.Susceptible;  % could this be sped up?

    % iterate along each node
    for node_i = 1:N
            
        % if the node is susceptible, will they become infected?
        if (currentNodes(node_i) == Node.Susceptible)

            % count how many of the neighbors are infected
            numInfectedNeighbors = 0;
            for node_j = 1:N
                % if another infected node is connected to this node
                if (adjacencyMatrix(node_j,node_i) == 1 && ...
                    (currentNodes(node_j) == Node.Infected))
                    numInfectedNeighbors = numInfectedNeighbors + 1;
                end
            end

            % try once, for each infected neighbor, to infect this node
            for node_j = 1:numInfectedNeighbors
                if (rand() <= (infectionRate * deltaT))
                    nextNodes(node_i) = Node.Infected;
                    break;
                end
            end

        % if the node is infected, will they become susceptible?    
        elseif (currentNodes(node_i) == Node.Infected)

            % if the given infected node does not recover
            if ~(rand() <= (recoveryRate * deltaT))
                nextNodes(node_i) = Node.Infected;
            end
        end
    end
end

