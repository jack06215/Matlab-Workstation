function [sampleBinVector, sampleDecVector ] = GenerateSampleVector( probabilityVector, nbSample )

sampleBinVector = zeros(nbSample, 36);
sampleDecVector = zeros(nbSample, 12);
for iSample = 1 : nbSample
    [solutionBinVector, solutionDecVector] = GenerateSolutionVector( probabilityVector );
    [maxTerminal] = MaxTerminal(solutionDecVector);
    while (maxTerminal > 4)
        [solutionBinVector, solutionDecVector] = GenerateSolutionVector( probabilityVector );
        [maxTerminal] = MaxTerminal(solutionDecVector);
    end
    sampleBinVector(iSample, 1:36) = solutionBinVector(1, 1:36);
    sampleDecVector(iSample, 1:12) = solutionDecVector(1, 1:12);
end
end