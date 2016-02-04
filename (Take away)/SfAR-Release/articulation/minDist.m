function [ bestInd, dist_return ] = minDist( bestVals, bestInds, LS_Hull, goodquadsP1, goodquadsP2,minDisThresh)
%Computes minimum distance of top 'n' scored articulation lines, returned by 
%bestNscores()
%
%   Inputs:
%       bestVals    -   Top 'n' best values returned be bestNscores()
%                       on which we need to apply minimum distance
%       bestInds    -   Corresponding indices of bestVals
%       LS_Hull     -   Line segments LS with convex hull of all
%                       regions appended to it
%       goodquadsP1 -   good quads from plane P1
%       goodquadsP2 -   good quads from plane P2
%       minDisThresh-   The maximum value of minDistance allowed,
%                       above which the funtion returns a False.
%
%   Outputs:
%       bestInd     -   The index of the articulation line which is
%                       has the minumum distance. If the minimum 
%                       distance found is greater than minDisThresh,
%                       it returns False.
%       dist_return -   The value of minimum distance to be returned.
%
%Written on 6th Sept, 2012 in SfAR revision.

%% min dist on top 5 scores
distances=inf(2,size(bestVals,2));
for i=1:size(bestVals,2)
    bestVal=bestVals(1,i);
    bestInd=bestInds(1,i);
    if bestVal>0.5
        dist1=ptsetmindistNew([LS_Hull(1:2,bestInd),LS_Hull(3:4,bestInd)],...
            reshape(goodquadsP1,2,numel(goodquadsP1)/2));
        dist2=ptsetmindistNew([LS_Hull(1:2,bestInd),LS_Hull(3:4,bestInd)],...
            reshape(goodquadsP2,2,numel(goodquadsP2)/2));
        distances(1,i)=dist1; distances(2,i)=dist2;
        
    end
end
[~,bestInd]=min(max(distances));

dist1=distances(1,bestInd);
dist2=distances(2,bestInd);
bestInd=bestInds(1,bestInd);
%lind
dist_return = dist1+dist2+1;
if ~(max(dist1,dist2)<=minDisThresh)
    bestInd = 0;
end

end

