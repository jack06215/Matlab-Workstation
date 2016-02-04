function [ artlineinds LS_Hull LS_Hull_c] = computeArticulation( psegs,rsegs,im,goodquads,LS,LS_c,planes,center,K,impath,talk,saveFig )
%Computes best articulation line between plane segment pairs, given plane 
%segmentation
%
%   To find the best articulation line between each plane
%   segment, among all line segments plausible lines are selected by an angle
%   threshold(i.e angleArtThresh defined in config file), followed by 
%   seperation score screening where the top N(i.e. n_art_lines defined in
%   config file) best lines are retained. One best line among the remaining
%   N is selected based on lowest minimum distance score.
%
%   Inputs:
%       psegs       -   Vector showing which plane each segment belongs to.
%                       psegs(<segment number>) = <plane number to which
%                       given segment number belongs>.
%                       It is given in form of a column vector.
%       rsegs       -   A logical array with each row showing if this rect
%                       belongs on this segment or not. 
%                       e.g., rsegs(i,:) would give logical indices for
%                       gooodquads such that goodquads(:,rsegs(i,:)) would give
%                       goodquads for ith segment.
%       im          -   image matrix in [(X,Y,3)]uint8 format
%       goodquads   -   Bad quads removed from all quads given by
%                       computeSegmentation. Each column of goodquads has 8
%                       rows, in the format :
%                       goodquads(i,:)=[x1 y1 x2 y2 x3 y3 x4 y4]';
%       LS          -   All line segments
%       LS_c        -   All line segments, with image center subtracted
%       planes      -   Plane matrix, where each column is the plane normal
%       center      -   image center
%       K           -   Camera matrix
%       impath      -   image path
%       talk        -   talk variable, if to show output or not
%       saveFig     -   whether to save the figures or not
%
%   Outputs:
%       artlineinds -   a vector showing which Line Segment number is
%                       articulation line for given segment pair.
%                       e.g. artlineinds(i,j) = <best art line between ith
%                       and jth segment>
%       LS_Hull     -   LS with convex hull appended
%       LS_Hull_c   -   LS_Hull with image center subtracted
%
%Written on 3rd December, 2012 in SfAR revision.

%% Constants:
minDistThresh = getParameter('minDistThresh');             %threshold for minDist, after which minDist function returns a False adn does not update the value articulation line
angleArtThresh = getParameter('angleArtThresh');             %the threshold on angle permissible articulation lines
n_art_lines = getParameter('n_art_lines');                %top n_art_lines are selected on which minimum distance algorithm is applied

%% initializing
k=length(psegs);
padj=zeros(k);
artlineinds=zeros(k);
pindex1=1;
hFig = [];
sepCell=cell(1,0);
rsegs=rsegs>0;
H = [];
%% append convex hull of all regions into LS_Hull
[LS_Hull,LS_Hull_c convexhull] = lsHullCompute(size(psegs,1),goodquads,LS,center,rsegs);
artthreshall = cell(1,0);
threshindex=[];
p2find=[];
%% Main loop for picking all plain pairs (pindex1,pindex2)
while pindex1<k
    pindex2=pindex1+1;
    while pindex2<=k
        if  psegs(pindex1)~=psegs(pindex2)                                  % for all non parallel plane pairs
            if talk
                fprintf(1,'\nplanes %d and %d\n',pindex1,pindex2)
            end
            
            %% 5' threshold
            [threshAngleList, LS_P1, LS_P2] = artAngleThresh(goodquads(:,rsegs(pindex1,:)),...
                goodquads(:,rsegs(pindex2,:)),...
                LS_Hull_c,center,K,...
                planes(:,[psegs(pindex1),psegs(pindex2)]),angleArtThresh);
                
            sepScores = sepScoresCompute(threshAngleList, size(LS_c,2), LS_P1, LS_P2, LS_Hull);
            
            sepCell=[sepCell sepScores];
            
            %% 5 best scores
            [bestVals, bestInds] = bestNscores( sepScores, n_art_lines );
%           artthreshall{end+1} = threshAngleList; 
            artthreshall{end+1} = bestInds;
            threshindex(end+1,:) = [pindex1 pindex2];
            %% min dist on top 5 scores
            [bestInd, dist_return] = minDist(    bestVals, bestInds, LS_Hull,...
                goodquads(:,rsegs(pindex1,:)), goodquads(:,rsegs(pindex2,:)),minDistThresh);
            
            if (bestInd)
                artlineinds(pindex1,pindex2)=bestInd;  % best articulation line
                padj(pindex1,pindex2)=dist_return;
            end
            %% visualize the result
            hFig = visualize_art_line(hFig,im,LS_P1,LS_P2,LS_Hull,bestInd,...
                                        pindex1,pindex2,artlineinds,talk);
        end
        pindex2=pindex2+1;
    end
    pindex1=pindex1+1;
end
% save('D:\data\sfarimprovement.mat','planes','goodquads','LS_Hull','LS_Hull_c','rsegs','psegs','artthreshall','threshindex','im','center','K');
p1=padj+padj';
[S,C] = graphconncomp(sparse(p1),'directed',false);
[~, V]=find(mode(C)~=C);
padj(V,:)=0;padj(:,V)=0;artlineinds(V,:)=0;artlineinds(:,V)=0;
%% MST
artlineinds = MST( padj,artlineinds );

%% print figs
if saveFig
    
    for i = 1:length(hFig)
        name = [impath '_t_articulation_' num2str(i) '_' get(hFig(1,i),'Name') '.efm'];
        print(hFig(i), '-dmeta', name);
        name = [impath '_t_articulation_' num2str(i) '_' get(hFig(1,i),'Name') '.jpg'];
        print(hFig(i), '-djpeg', name);
    end
end



end

