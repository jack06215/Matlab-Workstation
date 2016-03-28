function [planes,rsegs,psegs] = getPlanes(X,goodqseg2,goodqadj2)
%GETPLANES

% compute planes
k=size(X,2);
planes=zeros(3,k);
for index1=1:k
    ax=X(1,index1);ay=X(2,index1);
    Rtemp=makehgtform('xrotate',ax,'yrotate',ay); Rtemp=Rtemp(1:3,1:3);
    planes(:,index1)=Rtemp'*[0;0;1];
end

% construct the conflict-free adjacency matrix
newadj=zeros(size(goodqadj2));
[ind1,ind2]=find(goodqadj2>0);
matchpairs=(goodqseg2(ind1)==goodqseg2(ind2));
if sum(matchpairs)
    newadj(sub2ind(size(newadj),ind1(matchpairs),ind2(matchpairs)))=1;
end

% Find the strongly connected components
g=sparse(newadj>0); g=g+g';
[S,C] = graphconncomp(g,'DIRECTED',false);
% Remove the too small groups
newS=S; newC=C;
newS; newC;
% construct rsegs
rsegs=zeros(newS, length(newC));
for sindex=1:newS
    rsegs(sindex,:)=(newC==sindex);
end

% compute psegs
psegs=zeros(newS,1);
for sindex=1:newS
    curr_rects=find(rsegs(sindex,:));   % get the rects in current plane
    psegs(sindex)=goodqseg2(curr_rects(1)); % get orientation of first rect
end

end

