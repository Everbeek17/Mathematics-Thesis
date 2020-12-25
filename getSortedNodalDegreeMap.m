function [sortedMap] = getSortedNodalDegreeMap(adjacencyMatrix)
%creates a sorted map of node indexes to their nodal degrees
%   Detailed explanation goes here
    

    % TODO: replace this with a self-balancing binary tree for improved
    % efficiency

    N = length(adjacencyMatrix);
    % Allocate space
    nodalDegree = zeros(N, 1);
    
    % first value = index of node in Adjacency Matrix
    % second value = nodal degree of node
    
    % populate
    for i = 1:N
        nodalDegree(i) = sum(adjacencyMatrix(i, :));
    end
    
    % sort
    [B, I] = sort(nodalDegree);
    
    sortedMap = [I, B];
    
    
    
    
    
    
end

