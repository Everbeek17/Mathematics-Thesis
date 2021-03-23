function [nodalDegrees] = getNodalDegrees(adjacencyMatrix)
%Creates an array of nodal degrees.
%   Index = index of node in Adjacency Matrix.
%   Array value = nodal degree of node.
    
    % get number of nodes
    N = length(adjacencyMatrix);
    % allocate space
    nodalDegrees = zeros(N, 1);
    
    %% Populate array
    for i = 1:N
        % count the number of non-zero connections (in-degree) to this
        % node
        nodalDegrees(i) = sum(adjacencyMatrix(i, :) > 0);
    end
end

