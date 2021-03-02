function [nextNodes] = IncrementNodes_Binary(currentNodes, ...
    adjacencyMatrix, infectionRate, recoveryRate, deltaT)
%SIS_INCREMENT Summary of this function goes here
%   Detailed explanation goes here


    N = length(currentNodes);
    
    % create next iteration, defaulting all nodes to susceptible
    nextNodes = Node.empty(N, 0);
    
    % default all next nodes to susceptible
    nextNodes(1:N) = Node.Susceptible;  % TODO could this be sped up?

    % iterate along each node
    for node_i = 1:N
            
        % if the node is susceptible, will they become infected?
        if (currentNodes(node_i) == Node.Susceptible)

            % iterate over every neighbor
            for node_j = 1:N
                
                % check connection from this node to neighbor
                connectionStrength = adjacencyMatrix(node_i,node_j);
                
                % check if connection is greater than zero
                if (connectionStrength > 0)
                    
                    % check if the connected node is infected
                    if (currentNodes(node_j) == Node.Infected)
                    
                        % infection attempts to jump from node_j to node_i
                        if (rand() <= infectionRate * deltaT ...
                                * connectionStrength)
                            nextNodes(node_i) = Node.Infected;
                            
                            % if successful then stop iterating over
                            % neighbors, as we have already infected this 
                            % node.
                            break;
                        end
                    end
                end
            end

        % else if the node is infected, will they become susceptible?    
        elseif (currentNodes(node_i) == Node.Infected)

            % if the given infected node does not recover
            if ~(rand() <= (recoveryRate * deltaT))
                nextNodes(node_i) = Node.Infected;
            end
        end
    end
end

