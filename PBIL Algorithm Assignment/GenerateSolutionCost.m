%Find the cost for 1 sample
function [ sampleCost ] = GenerateSolutionCost( CostMatrix, sampleDecVector )

sampleCost = zeros(size(sampleDecVector, 1), 1);
for iSample = 1:size(sampleDecVector, 1)
    cost = 0;
    for iTerminal = 1: size(sampleDecVector, 2)
        cost = cost + CostMatrix(iTerminal, sampleDecVector(iSample, iTerminal));
    end
    sampleCost(iSample, 1) = cost;
end
end