function [ sepScores ] = sepScoresCompute( threshAngLst, size_LS_c, LS_P1, LS_P2, LS_Hull )
%Computes seperation Scores for articulation lines of given two planes
%   It uses the function sepscoreNew function on shList(i.e. the articulation
%   lines returned by artAngleThresh) and returns them in sepScores
%
%   Inputs:
%       threshAngLst-   The list of articulation lines lying within a
%                       threshold list.
%       size_LS_c   -   size(LS_c,2) i.e. number of lines in LS_c
%       LS_P1       -   Line segments of endpoints of quads of plane 1
%       LS_P2       -   Line segments of endpoints of quads of plane 2
%       LS_Hull     -   LS line segments with convex hull of all regions appended.
%
%   Outputs:
%       sepScores   -   Seperation scores of lines given in threshAngLst

%% initialise sepscores
sepScores=zeros(1,size_LS_c);

%% seperation score
for i=1:size(threshAngLst,2)
    sepScores(threshAngLst(1,i))=sepscoreNew(LS_Hull(:,threshAngLst(1,i)),[LS_P1(1:2,:),LS_P1(3:4,:)],[LS_P2(1:2,:),LS_P2(3:4,:)]);
end


end

