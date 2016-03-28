function [ bestVals bestInds ] = bestNscores( sepScores, n )
%Picks n best scores out of sepScores returned by sepScoresCompute
%   Uses simple sort function to arrange sepScores and then picks the top n
%   results.
%   
%   Input:
%       sepScores   -   seperation score of possible articulation 
%                       lines returned by sepScoresCompute
%       n           -   Number of top scoring lines to be returned
%
%	Outputs:
%       bestVals    -   Values 
%       bestInds    -   Indices of the corresponding values in bestVals
%
%Written on 6th Sept, 2012 in SfAR revision.


[bestVals,bestInds]=sort(sepScores,'descend');
bestVals=bestVals(1,1:n);
bestInds=bestInds(1,1:n);

end

