function [ probabilityVector ] = MutateProbabilityVector( probabilityVector, mutationProbability, mutationShift )
    for iBit = 1:size(probabilityVector)
        if rand < mutationProbability
            shift = (rand < 0.5) * mutationShift;
            base = probabilityVector(iBit) * (1 - mutationShift);
            probabilityVector(iBit) = base + shift;
        end
    end
end

