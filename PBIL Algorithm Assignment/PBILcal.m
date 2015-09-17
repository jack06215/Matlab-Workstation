
function [bestCost]=PBILcal(SampleSize,NumGen)


% Cost Matrix

cost = [1  2  3  4  5  6  7  8;
        0  1  2  3  4  5  6  7;
        8  9  10 11 12 12 14 1;
        1  3  5  7  9  11 13 15;
        1  5  7  6  3  8  9  1;
        2  9  8  5  6  3  8  1;
        16 2  9  5  7  3  5  2;
        3  4  6  2  8  9  5  3;
        5  11 20 5  7  4  8  9;
        1  6  8  7  66 44 2  5;
        21 27 5  4  3  2  8  1;
        8  9  5  7  3  7  11 9];

%Constraint
MaxConcenPerTerminal = 4;  

% GenerateProbabilityVector
Prob_Vector = ones (12, 3)*0.5;

% Generate a potential solution;
solutionBinVector = zeros (12, 3);
solutionDecVector = zeros (12, 1);

%initiate the temporary cost
temp_cost = 0;

% Repeats for Number of generations.
for a= 1:100
    
    % Assign minimum cost a high value initially = 1000;
    
    minCost = 1000;
    
    % Repeats for the number of samples - population
    
    for b=1: 100
        temp_cost = 0;
        for i=1:12
            
            %Generate the bit ramdomly according to the respective probability vector;
            for j=1:3
                solutionBinVector (i, j) = (rand ()  < Prob_Vector (i, j));
            end
            
            %Convert the word into decmal and Store the word into solutionDecVector;
            solutionDecVector(i) = bin2dec([int2str(solutionBinVector(i,1)) '' 			int2str(solutionBinVector(i,2)) '' int2str(solutionBinVector(i,3)) ]);
            
            temp_cost = temp_cost + cost (i, solutionDecVector (i) +1);
        end
        
        % Check the constraints
        check = 0;
        for i=0:7
            
            % Check to see if eaih row has more than the allowed number of allocations
            check = check + ((sum (solutionDecVector==i))> MaxConcenPerTerminal);
        end
        
        
        if check == 0
            % Check if it is the lowest(minimum) cost
            if temp_cost < minCost
                
                % Make the current minimum the best cost
                minBinVector = solutionBinVector;
                minDecVector = solutionDecVector;
                minCost = temp_cost;
            end
        end
    end
    
    % Changes the Probability vector
    Prob_Vector = Prob_Vector*(1-0.05) + 0.05*minBinVector;
    
    
    bestCost (a) = minCost;
end
end