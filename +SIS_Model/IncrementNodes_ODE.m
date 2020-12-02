function [nextProbabilities] = IncrementNodes_ODE(...
    currentProbabilities, adjacencyMatrix, infectionRate, ...
    recoveryRate, deltaT)
%SIS_INCREMENT Summary of this function goes here
%   Detailed explanation goes here
%   for each node, calculate the rate of change of its current probability
%   then take the average of all the probability rate of changes for each
%   time step and return an array of those.
    
    nextProbabilities = currentProbabilities;

    N = length(adjacencyMatrix(1,:));

    % iterate along each node
    for i = 1:N
         
        % calculate the rate of change of the current node
        deltaP = ODE_Equation(infectionRate, recoveryRate, ...
            currentProbabilities, i, adjacencyMatrix);
        
        % use Newton's Method to find new peobability after deltaT
        nextProbabilities(i) = currentProbabilities(i) + deltaP * deltaT;
        
    end
end

function [deltaP] = ODE_Equation(beta, gamma, P, i, A)

    deltaP = -gamma * P(i);
    
    % sum over every connected node
    sum = 0;
    for j = 1:length(P)
        sum = sum + A(i, j) * P(j);
    end
    
    deltaP = deltaP + beta * (1 - P(i)) * sum;

end