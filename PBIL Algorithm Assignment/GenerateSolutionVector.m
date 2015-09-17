%For 1 sample - population
function [solutionBinVector, solutionDecVector] = GenerateSolutionVector( probabilityVector )
    solutionBinVector = zeros(1, 36);
    solutionDecVector = zeros(1, 12);
    for i = 1:12
        startBit = ((i - 1) * 3) + 1;
        bit3 = (rand < probabilityVector(1, startBit));
        bit2 = (rand < probabilityVector(1, startBit + 1));
        bit1 = (rand < probabilityVector(1, startBit + 2));
        solutionBinVector(1, startBit) = bit3;
        solutionBinVector(1, startBit + 1) = bit2;
        solutionBinVector(1, startBit + 2) = bit1;
        %Convert from binary to decimal vector and indicate which
        %concentrators are connected
        solutionDecVector(1, i) = (bit3 * 4) + (bit2 * 2) + (bit1) + 1;
    end
end