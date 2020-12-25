function [nextNodes] = IncrementNodes_Binary(currentNodes, ...
    adjacencyMatrix, infectionRate, recoveryRate, deltaT)


    N = length(currentNodes);
    
    % create next iteration, defaulting all nodes to Susceptible
    nextNodes = Node.empty(0, N);
    nextNodes(1:N) = Node.Susceptible;

    % iterate along each node
    for node_i = 1:N
            
        % if the node is susceptible, will they become infected?
        if (currentNodes(node_i) == Node.Susceptible)

            % count how many of the neighbors are infected
            numInfectedNeighbors = 0;
            for node_j = 1:N
                % if another infected node is connected to this node
                if (adjacencyMatrix(node_i,node_j) == 1 && ...
                    (currentNodes(node_j) == Node.Infected))
                    numInfectedNeighbors = numInfectedNeighbors + 1;
                end
            end

            % try once, for each infected neighbor, to infect this node
            % using the infection rate value to decide likelyhood of
            % successful infection.
            for node_j = 1:numInfectedNeighbors
                if (rand() <= (infectionRate * deltaT))
                    nextNodes(node_i) = Node.Infected;
                    break;
                end
            end
        
        % if the node is infected, will they become recovered?    
        elseif (currentNodes(node_i) == Node.Infected)

            % if the given infected node does not recover
            % (stay infected)
            if ~(rand() <= (recoveryRate * deltaT))
                nextNodes(node_i) = Node.Infected;
            else
                % else they recover
                nextNodes(node_i) = Node.Recovered;
            end
        
        % if the node is recovered, it stays recovered
        elseif (currentNodes(node_i) == Node.Recovered)
            nextNodes(node_i) = Node.Recovered;
        end  
    end
end

