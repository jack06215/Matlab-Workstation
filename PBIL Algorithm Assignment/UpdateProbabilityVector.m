function [ probabilityVector ] = UpdateProbabilityVector( SolutionBinVector, probabilityVector, learningRate )
    for iBit = 1:size(SolutionBinVector, 2);
        base = probabilityVector(1, iBit) * (1 - learningRate);
        shift = SolutionBinVector(1, iBit) * learningRate;
        probabilityVector(1, iBit) = base + shift;
    end
end

