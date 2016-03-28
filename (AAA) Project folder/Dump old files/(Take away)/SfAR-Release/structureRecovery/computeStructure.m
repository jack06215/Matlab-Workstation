function [planes,im,H,pts,xp] = computeStructure(im,artlineinds,X,psegs,rsegs,goodinds,LS_c,LS_Hull_c,K,center,goodquads)

%Computes 3D structure given plane segmentations and articulation lines between them
%
%   Structure is computed by following series of steps:
%       1) All unique plane segments are gathered, among whom articulation
%          lines exist
%       2) A non-liner optimization is run over plane normals, to minimze
%          distance between planes and to maximize angular regularity
%          constraint
%       3) Based on the optimization, find new plane equations
%       4) Intersect the optimized planes to find optimized articulation
%          lines
%       5) Compute homographies for each plane
%
%   Inputs:
%       im          -   image matrix in [(X,Y,3)]uint8 format
%       artlineinds -   a vector showing which Line Segment number is
%                       articulation line for given segment pair.
%                       e.g. artlineinds(i,j) = <best art line between ith
%                       and jth segment>
%       X           -   Plane normal vectors, where normal for each plane
%                       is stored in columns
%       psegs       -   Vector showing which plane each segment belongs to.
%                       psegs(<segment number>) = <plane number to which
%                       given segment number belongs>.
%                       It is given in form of a column vector.
%       rsegs       -   A logical array with each row showing if this rect
%                       belongs on this segment or not. 
%                       e.g., rsegs(i,:) would give logical indices for
%                       gooodquads such that goodquads(:,rsegs(i,:)) would give
%                       goodquads for ith segment.
%       goodinds    -   Good indices of rects computed based on rectangles
%       LS_c        -   All line segments, with image center subtracted
%       LS_Hull_c   -   All line segments including convex hull, with image
%                       center subtracted
%       K           -   Camera matrix
%       center      -   image center
%       goodquads   -   Bad quads removed from all quads given by
%                       computeSegmentation. Each column of goodquads has 8
%                       rows, in the format :
%                       goodquads(i,:)=[x1 y1 x2 y2 x3 y3 x4 y4]';
%
%   Outputs:
%       planes      -   Plane matrix, where each column is the plane normal
%       im          -   image matrix in [(X,Y,3)]uint8 format
%       H           -   Plane homograpies placed in cell structure
%       pts         -   pts for each segment,placed in cell structure
%       xp          -   non-liner optimization output
%
%Written on 3rd December, 2012 in SfAR revision.



[unique_segs,r,c,v]=getUniqueSegs(artlineinds);
[Xnew,Lines,seg,inliers]= augmentlines_allplanes (unique_segs,X,psegs,rsegs,goodinds,LS_c);

[artSeg,segAdj,art]=getartSeg(r,c,v,unique_segs,LS_Hull_c);

%%
PArt_im_c=art;              %convention issues; points of all art lines
L_im_2p_c = Lines;          %convention issues
L_im=twopts2L(L_im_2p_c);

xp = optimize(PArt_im_c,L_im,K,Xnew,seg,inliers,artSeg,segAdj);

Kp=diag([xp(1),xp(1),1]);
no_of_segs=size(seg,1);
planes = findOptimizedPlanes(xp,no_of_segs,PArt_im_c,segAdj,Kp,artSeg);		%including the distance entries


hFig=[];
[PArt_im_c,artSeg]=getNewArts(planes, artSeg, PArt_im_c,Kp);        %convention issues
artLine=PArt_im_c+repmat(center,1,size(PArt_im_c,2));
artLine=[artLine(:,1:2:end);artLine(:,2:2:end)];

planeArt = getplaneArt(segAdj,artSeg,PArt_im_c,center);             %each cell contains all art lines of that plane with all other planes

pts=getPtsAndLines(planeArt,seg,L_im_2p_c,center,unique_segs,artLine,goodquads,rsegs);
imscale=0;


if imscale<=0 && max([size(im,1),size(im,2)])>1000
    imscale=1000/max([size(im,1),size(im,2)]);
    im=imresize(im,imscale);
end

H = getH(xp,Kp,center,size(pts));
