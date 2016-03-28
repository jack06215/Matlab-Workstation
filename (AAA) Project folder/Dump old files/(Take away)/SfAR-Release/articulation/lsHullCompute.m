function [ LS_Hull LS_Hull_c hull] = lsHullCompute( size_psegs, goodquads, LS, center, rsegs )
%Computes convex hull of all regions and appends them to LS, returns LS
%with convex hull appended.
%   Inputs:
%       size_spegs  -   size(psegs,1)
%       goodquads   -   Good quads, Subtracting bad quads from all quads
%       LS          -   All line segments
%       center      -   Mid point of image [xMid;yMid]
%       rsegs       -   vector showing which quad lies in which region number
%   Outputs:
%       LS_Hull     -   Line segments with convex hull of each region appended
%       LS_Hull_c   -   LS_Hull with image mean subtracted
%
%Written on 10th Sept, 2012 in SfAR revision.
LS_Hull = LS;
hull=cell(0,1);
for index=1:size_psegs
    %pick all vertices of goodquads(bad indices removed from quads) in current region
    temp=[goodquads(1:2,rsegs(index,:)),goodquads(3:4,rsegs(index,:))...
        ,goodquads(5:6,rsegs(index,:)),goodquads(7:8,rsegs(index,:))];
    %temp = reshape(goodquads(index,:),2,numel(goodquads(index,:))/2);
    inds=convhull(temp(1,:),temp(2,:));
    pts=temp(1:2,inds);                 %pts of only convex hull of the plane
    
    pts=[pts(1:2,1:end-1) pts(1:2,end);pts(1:2,2:end) pts(1:2,1)];
    % pts = [1 2 3 4 5] -> [1 2 3 4 5; 2 3 4 5 1] i.e forming line
    % segments out of pts(convex hull region)
    LS_Hull=[LS_Hull,pts];
    hull{index}=pts;
end
LS_Hull_c=LS_Hull-repmat(center,2,size(LS_Hull,2));

end

