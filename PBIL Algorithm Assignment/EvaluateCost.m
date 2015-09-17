%Find one best (lowest) cost from all generations
function [ minCost, optimalSampleBinVector, optimalSampleDecVector ] = EvaluateCost( CostMatrix, sampleBinVector, sampleDecVector )

sampleCost = GenerateSolutionCost(CostMatrix, sampleDecVector);

minCost = min(sampleCost);      %Find the lowest cost within 1 generation
solutionIndex = min(find(sampleCost == minCost));

optimalSampleBinVector = sampleBinVector([solutionIndex], 1:size(sampleBinVector, 2));
optimalSampleDecVector = sampleDecVector([solutionIndex], 1:size(sampleDecVector, 2));

end
