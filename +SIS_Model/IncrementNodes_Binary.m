function [nextNodes] = IncrementNodes_Binary(currentNodes, adjacencyMatrix, infectionRate, recoveryRate, deltaT)
%Stochastically decides what the next Binary iteration will look like.
%   This function creates the nodes for the next time step, deciding who
%   is infected and who isn't using stochastic principles, an adjacency
%   matrix, and other parameters.

    % saves the total number of nodes N
    N = length(currentNodes);
    
    % allocates space for the next iteration/state
    nextNodes = Node.empty(N, 0);
    
    % defaults all the nodes of the next iteration/state to susceptible
    nextNodes(1:N) = Node.Susceptible;

    % iterate along each node
    for node_i = 1:N
            
        % if the node is susceptible, will they become infected?
        if (currentNodes(node_i) == Node.Susceptible)

            % iterate over every neighbor
            for node_j = 1:N
                
                % check connection from neighbor (node_j) to this node
                % (node_i)
                connectionStrength = adjacencyMatrix(node_i,node_j);
                
                % check if connection is greater than zero
                if (connectionStrength > 0)
                    
                    % check if the connected node is infected
                    if (currentNodes(node_j) == Node.Infected)
                    
                        % infection attempts to jump from node_j to node_i
                        if (rand() <= infectionRate * deltaT ...
                                * connectionStrength)
                            nextNodes(node_i) = Node.Infected;
                            
                            % if infection was successful, then stop 
                            % iterating over neighbors, as we have already
                            % infected this node.
                            break;
                        end
                    end
                end
            end

        % else, if the node is infected, will they become susceptible?    
        elseif (currentNodes(node_i) == Node.Infected)

            % if the given infected node does not recover
            if ~(rand() <= (recoveryRate * deltaT))
                nextNodes(node_i) = Node.Infected;
            end
        end
    end
end

