function [nodes] = CreateInitialNodes(chanceOfInitialInfection, N)
%CREATEINITIALSTATES Summary of this function goes here
%   Detailed explanation goes here
    


    nodes = Node.empty(N, 0);

    for i = 1:N
        % if statement passes with the chance given in
        % chanceOfInitialInfection
        if (rand() <= chanceOfInitialInfection)
            nodes(i) = Node.Infected;
        else
            nodes(i) = Node.Susceptible;
        end
        
    end



end

