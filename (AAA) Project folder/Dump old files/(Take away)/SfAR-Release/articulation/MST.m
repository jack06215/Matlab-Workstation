function [ artlineinds ] = MST( planeAdj,artlineinds )
%Computes Minimum spanning tree of the planes
%   In the variable artlineinds, it computes MST and removes required
%   articulation line indices. It uses the function graphminspantree() to
%   compute the MST.
%   where artlineinds is a matrix showing which two planes are 
%   connected by which line as articulation line.
%   artlineinds(plane1,plane2)= line number which acts as their
%   articulation line.
%
%   Inputs:
%       planeAdj    -   Plane adjacency matrix
%       artlineinds -   matrix showing which two planes are 
%                       connected by which line as articulation line.
%                       artlineinds(plane1,plane2)= line number 
%                       which acts as their articulation line.
%
%   Outputs:
%       artlineinds -   Upadted value of the variable with MST applied.
%Written on 6th Sept, 2012 in SfAR revision.

planeAdjSparse=sparse(planeAdj); planeAdjSparse=planeAdjSparse+planeAdjSparse';

% Find the strongly connected components
spanAdjSparse = graphminspantree(planeAdjSparse);
spanAdj=full(spanAdjSparse);
spanAdj=spanAdj';
check=spanAdj>0;
for i=1:size(check,1)
    for j=1:size(check,2)
        if ~check(i,j)
            artlineinds(i,j)=0;
        end
    end
end

end

