function [ maxTerminal ] = MaxTerminal( solutionDecVector )
    terminalCount = zeros(1, 8);
    for iTerminal = 1:12
        concentrator = solutionDecVector(1, iTerminal);
        terminalCount(1, concentrator) = terminalCount(1, concentrator) + 1;
    end
    maxTerminal = max(terminalCount);
end
