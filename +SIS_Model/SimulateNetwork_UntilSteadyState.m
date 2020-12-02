function [r_Infinity, elapsedSeconds] = ...
    SimulateNetwork_UntilSteadyState(...
    initialNodes, adjacencyMatrix, infectionRate, recoveryRate, ...
    minSimulationLength, deltaT, steadyStateWiggleRoom, steadyStateSeconds)
%SimulateNetwork_SIS_UntilSteadyState Summary of this function goes here
%   Detailed explanation goes here


    N = length(initialNodes);

    % number of prior values taken into consideration when looking for
    % steady state
    wiggleSize = length(0:deltaT:steadyStateSeconds);
    
    % initialize variables
    numInfected = zeros(wiggleSize, 1);
    numSusceptible = zeros(wiggleSize, 1);
    
    currentNodes = initialNodes;
    iteration = 1;  % counts how many iterations it took
    
    % calulate this once at the beginning, and then again after each loop
    numInfected(1) = sum(currentNodes(:) == Node.Infected);
    numSusceptible(1) = sum(currentNodes(:) == Node.Susceptible);
    
    % iterate until we are at the steady state
    atSteadyState = 0;
    while (atSteadyState == 0)
        
        % iterate
        iteration = iteration + 1;
        currentNodes = SIS_Model.IncrementNodes(currentNodes, adjacencyMatrix, ...
            infectionRate, recoveryRate, deltaT);
        
        % save value to array (overwriting as we go to only keep last
        % wiggleSize number of iterations)
        numInfected(mod(iteration, wiggleSize) + 1) ...
            = sum(currentNodes(:) == Node.Infected);
        numSusceptible(mod(iteration, wiggleSize) + 1) ...
            = sum(currentNodes(:) == Node.Susceptible);
        
        
        % only start checking for steady state after given minSeconds
        if (iteration >= minSimulationLength/deltaT)
        
            % check if last wiggleSize iterations all fall within the
            % specified steady state range, if they do then we have reached
            % the steady state value.
            % BETTER EXPLANATION:
            % If the difference between the highest and lowest values of
            % the last couple iterations 
            
            min_r_Infinity = min(numInfected(:)) / N;
            max_r_Infinity = max(numInfected(:)) / N;
            
            % i
            if ((max_r_Infinity - min_r_Infinity) < steadyStateWiggleRoom)
                atSteadyState = true;
                % calculate r_Infinity value as the average of the prior
                % r values.
                r_Infinity = sum(numInfected(:) / N) / wiggleSize;
                
            end
        end
    end
            
    % save return number of seconds passed
    elapsedSeconds = iteration*deltaT;
end


