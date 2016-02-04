function [im,K,center,LS,LS_c,goodquads2,planes,rsegs,psegs,X,goodinds] = computeSegmentation(impath,talk)

%Computes segmentation for the given image.
%
%   The segmentation process is carried out by the following steps:
%       1) Read the image and its focal length by EXIF data
%       2) Detect the lines and extend them using LSD of ******
%       3) Get the orientations of various planes in image, using RANSAC
%       4) Extract all rectangles found in the image using line segment
%          intersections, and forming all possible rectangles by each
%          intersection
%       5) Compute conflict score of each rectangle formed
%       6) Remove conflicting rectangles based on conflict score comupted
%       7) Show output and save figures
%
%   Inputs:
%       impath      -   image path to compute segmentation
%
%   Outputs:
%       im          -   image matrix in [(X,Y,3)]uint8 format
%       K           -   Camera matrix
%       center      -   image center
%       LS          -   All line segments
%       LS_c        -   All line segments, with image center subtracted
%       goodquads2  -   Bad quads removed from all quads given by
%                       computeSegmentation. Each column of goodquads has 8
%                       rows, in the format :
%                       goodquads(i,:)=[x1 y1 x2 y2 x3 y3 x4 y4]';
%       planes      -   Plane matrix, where each column is the plane normal
%       rsegs       -   A logical array with each row showing if this rect
%                       belongs on this segment or not. 
%                       e.g., rsegs(i,:) would give logical indices for
%                       gooodquads such that goodquads(:,rsegs(i,:)) would give
%                       goodquads for ith segment.
%       psegs       -   Vector showing which plane each segment belongs to.
%                       psegs(<segment number>) = <plane number to which
%                       given segment number belongs>.
%                       It is given in form of a column vector.
%
%Written on 3rd December, 2012 in SfAR revision.


saveFig = getParameter('saveFig');
gapfillflag = getParameter('gapfillflag');  % fill gaps between colinear line segments
extendflag = getParameter('extendflag');   % extend lines
scaleimageflag = getParameter('scaleimageflag');
LSDscale = getParameter('LSDscale');
maxlines = getParameter('maxlines');
athreshgap = getParameter('athreshgap');
dthreshgap = getParameter('dthreshgap');
athreshadj = getParameter('athreshadj');
highthresh = getParameter('highthresh');
numPairs = getParameter('numPairs');
maxTrials = getParameter('maxTrials');
maxDataTrials = getParameter('maxDataTrials');
poptype = getParameter('poptype');

%% read the input, detect lines, preprocess, segment into regions
[im,K,center] = cameraInputs(impath,scaleimageflag);

[LS,Ladj,LS_c,L,hFig] = lineDetection(im,center,LSDscale,gapfillflag,extendflag,maxlines,athreshgap,dthreshgap,athreshadj,talk);

%% form plane orientation hypotheses

disp('into plane orientation')
[X,inliers,numhyp] = getPlaneOrientation(Ladj,L,K,highthresh,numPairs,maxTrials,maxDataTrials,poptype,talk);

%% find unique region labels

disp('into getquads')
[Ladj,rectangles,inds,numRectangles,quads_c,qseg] = getRectangles(Ladj,LS_c,L,X,inliers,numhyp,K,center);

%% compute their hypothesis scores
fprintf(1,'computing hypotheses scores\n');
inpercent = getRectanglesHypothesisScore(L,Ladj,rectangles,numRectangles,quads_c,inliers,numhyp);


%% compute their adjacency matrix
fprintf(1,'computing quadrangle adjacency\n');
qadj=findOverlapWithSAP(rectangles);

%% conflict removal
[goodquads2,goodqseg2,goodqadj2,badquads2,badqseg2,goodqadj2vis,goodinds] = removeConflicts(inpercent,rectangles,qadj,qseg,inds);

%% visualize results
% hFig=[];
if talk
    hFig=[hFig az_fig];showquads(im,rectangles,qseg,LS,0.1);
    axis([0,size(im,2),0,size(im,1)]); set(hFig(1,end),'Name','All Rectangles');
    hFig=[hFig az_fig];showquads(im,goodquads2,goodqseg2,LS,0.1);
    axis([0,size(im,2),0,size(im,1)]); set(hFig(1,end),'Name','Good Rectangles');
    hFig=[hFig az_fig];showquads(im,badquads2,badqseg2,LS,0.1);
    axis([0,size(im,2),0,size(im,1)]); set(hFig(1,end),'Name','Bad Rectangles');
    hFig=[hFig az_fig]; subplot(1,2,1), imshow(qadj),  subplot(1,2,2), imshow(goodqadj2vis),set(hFig(1,end),'Name','Adjacency Matrices');

    fprintf(1, '\n---\nTotal %d\nGood %d\n\n',size(rectangles,2),size(goodquads2,2));
end

%%
if saveFig
    for i = 1:     length(hFig)
        name = [impath '_segmentation_' num2str(i) '_' get(hFig(1,i),'Name') '.efm'];
        print(hFig(i), '-dmeta', name);
        name = [impath '_segmentation_' num2str(i) '_' get(hFig(1,i),'Name') '.jpg'];
        print(hFig(i), '-djpeg', name);
    end
end

[planes,rsegs,psegs] = getPlanes(X,goodqseg2,goodqadj2);
rsegs=rsegs>0;





end



