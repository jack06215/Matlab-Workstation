clear all;
clc;
%   Cost Lookup Table
CostMatrix = [1  2  3  4  5  6  7  8;
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
%   Some variables
nbGeneration            = 100;
nbSample                = 100;
learningRate            = 0.04;
mutationProbability     = 0.1;
mutationShift           = 0.2;
%   Some storage vector
probabilityVector       = ones (1, 36) * 0.5;
minCostVector           = zeros(nbGeneration, 1);
%   Run PBIL simulation
%   Store the cost vector for each generation
for i = 1:nbGeneration
    [ solutionBinVector, solutionDecVector ] = GenerateSampleVector( probabilityVector, nbSample );
    [ minCost, optimalSampleBinVector, optimalSampleDecVector ] = EvaluateCost( CostMatrix, solutionBinVector, solutionDecVector );
    probabilityVector  = UpdateProbabilityVector( optimalSampleBinVector, probabilityVector, learningRate );
    [ probabilityVector ] = MutateProbabilityVector( probabilityVector, mutationProbability, mutationShift );
    
    minCostVector(i, 1) = minCost;
end

plot(minCostVector);
ylabel('Cost');
xlabel('Generation');
title('Cost with Generations');