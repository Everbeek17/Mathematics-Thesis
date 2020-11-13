function [adjMatrix] = CreateAdjacencyMatrix(N, k)
%CREATENETWORKMATRIX Returns NxN matrix with mean degree k
%   Detailed explanation goes here

    fprintf("generating nice Adjacency matrix...");

    nice_flag = false;
    
    while (~nice_flag) 
        adjMatrix = zeros(N);

        totalNumLinks = N * k / 2;

        % place links randomly throughout the matrix
        for i = 1:totalNumLinks

            % repeatedly pick random indices until a valid one gets picked
            rowIndex = randi(N);
            colIndex = randi(N);
            while ((colIndex == rowIndex) || (adjMatrix(rowIndex, colIndex) == 1))
                % pick another random index
                rowIndex = randi(N);
                colIndex = randi(N);
            end

            % set link to exist in both directions
            adjMatrix(rowIndex, colIndex) = 1;
            adjMatrix(colIndex, rowIndex) = 1;

        end
        
        % check if A is nice, if not try again
        % (if all entries after being raised to a power are nonnegative
        if (min(min(adjMatrix^20)) > 0)
            nice_flag = true;
        end
    end
    fprintf("Done.\n");
end

