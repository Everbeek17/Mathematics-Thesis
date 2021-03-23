function [sortedMap] = getSortedNodalDegreeMap(adjacencyMatrix)
%Creates a sorted map from node index to nodal degree.
%   Map is in increasing (non-decreasing) order.
%   First value = index of node in Adjacency Matrix.
%   Second value = nodal degree of node.
    
    %% Get nodal degrees
    nodalDegrees = getNodalDegrees(adjacencyMatrix);
    
    %% Sort map
    [NodalDegrees, Indices] = sort(nodalDegrees);
    % put indices first, nodal degrees second
    sortedMap = [Indices, NodalDegrees];
end

