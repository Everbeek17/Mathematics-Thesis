function [nextProbabilities] = IncrementNodes_ODE(currentProbabilities, adjacencyMatrix, infectionRate, recoveryRate, deltaT)
%Decides next iteration probabilities by ODE equation.
%   For each node, calculate its derivative of its probability of
%   infection, then iterate it to its next probability of infection using
%   Newton's Method.
    
    % initialize next probabilites to current probabilities
    nextProbabilities = currentProbabilities;
    
    % save number of nodes N
    N = length(adjacencyMatrix(1,:));

    % iterate over each node
    for i = 1:N
         
        % calculate the rate of change of the current node, using ODE
        % equation
        deltaP = ODE_Equation(infectionRate, recoveryRate, ...
            currentProbabilities, i, adjacencyMatrix);
        
        % use Newton's Method to find new probability after deltaT
        nextProbabilities(i) = currentProbabilities(i) + deltaP * deltaT;
        
        % Special case check: make sure we don't go over 1 or below 0
        if (nextProbabilities(i) > 1)
            nextProbabilities(i) = 1;
        elseif (nextProbabilities(i) < 0)
            nextProbabilities(i) = 0;
        end
    end
end

% ODE equation we plug into
function [deltaP] = ODE_Equation(beta, gamma, P, i, A)

    deltaP = -gamma * P(i);
    
    % sum over every connected node
    sum = 0;
    for j = 1:length(P)
        sum = sum + A(i, j) * P(j);
    end
    
    deltaP = deltaP + beta * (1 - P(i)) * sum;

end