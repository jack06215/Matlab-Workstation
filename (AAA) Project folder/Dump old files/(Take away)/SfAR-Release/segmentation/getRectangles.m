function [Ladj,quads,inds,numquads,quads_c,qseg] = getRectangles(Ladj,LS_c,L,X,inliers,numhyp,K,center)

% inputs
% Ladj: adjacency matrix for line segments
% LS_c: detected line segments in the center coordinates
% L: line segments in vector format
% X:
% inliers:
% numhyp: number of plane hypothesis
% K: camera matrix
% u0,v0: image center
% outputs
% Ladj: adjacency matrix for line segments, now a full matrix
% quads: the end points of the quads detected
% inds:
% numquads: number of quads per plane hypothesis
% quads_c: quads shifted to the center
% qseg: segmentation of quads into planes



%% find unique region labels
% script for binary rectangle cut segmentation algorithm

singleoverlapquadflag=1;
% Ladj=Ladj+Ladj';

%% form all possible rectangles/quadrangles
fprintf(1,'computing quadrangles\n');
quads=zeros(8,0);
inds=zeros(2,0);
numquads=[];
for index=1:numhyp   % number of hypotheses
    % form current H
    ax=X(1,index);ay=X(2,index);
    R=makehgtform('xrotate',ax,'yrotate',ay); R=R(1:3,1:3);
    H=K*R*inv(K);
    
    % get current quadrangles
    [currquads,currinds]=getquads(LS_c,L,H,Ladj.*inliers{index},singleoverlapquadflag);
    numquads(index)=size(currquads,2);
    quads=[quads,currquads];
    inds=[inds,currinds];
end

quads_c=quads;
quads=quads_c+repmat(center,4,size(quads_c,2));

qseg=zeros(1,size(quads,2));
for hindex=1:numhyp
    qseg((sum(numquads(1:hindex-1))+1):sum(numquads(1:hindex)))=hindex;
end

end

