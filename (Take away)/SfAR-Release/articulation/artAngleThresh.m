function [ threshAngleList LS_P1 LS_P2 ] = artAngleThresh( goodquadsP1,goodquadsP2,LS_Hull_c,center,K,planes12,angleArtThresh )
%ARTANGLETHRESH Find the articulation lines which lie inside a specified
%angle threshold
%   This function works by computing artScores using the function
%   findDistancesNew().
%
%   Inputs: 
%       goodquadsP1 -   good quads of plane P1
%       goodquadsP2 -   good quads of plane P2
%       LS_Hull_c   -   LS with convex hull of all regions appended,
%                       and mean subtracted
%       center      -   Mid point of image
%       K           -   Camera matrix
%       size_LS_c   -   [removed] size(LS_c,2) i.e. number lines in LS_c 
%       planes12    -   values of current two planes picked from 
%                       planes matrix
%       angleArtThresh - The maximum value of angle allowed for 
%                       plausible articulation lines
%
%	Output: 
%       threshAngleList - Thresholded articulation lines (plausable)
%       LS_P1       -   Line segments of endpoints of quads of plane 1
%       LS_P2       -   Line segments of endpoints of quads of plane 2
%
%Written on 4th Sept, 2012 in SfAR revision.

%% initialise atriculation score
%artscores=inf(1,size_LS_c);


%% Forming line segments from end points of quads of region1

%This section might be moved into another function<==================

LS_P1 = [ [goodquadsP1(1:4,:)],...
    [goodquadsP1(3:6,:)],...
    [goodquadsP1(7:8,:) ; goodquadsP1(1:2,:)]];
%subtract midpoint of image to align image midpoint with origin
LSP1_c=LS_P1-repmat(center,2,size(LS_P1,2));

%% Forming line segments from end points of quads of region2
LS_P2 = [ [goodquadsP2(1:4,:)],...
    [goodquadsP2(3:6,:)],...
    [goodquadsP2(7:8,:) ; goodquadsP2(1:2,:)]];

%subtract midpoint of image to align image midpoint with origin
LS2_c=LS_P2-repmat(center,2,size(LS_P2,2));

artline=[LS_Hull_c(1:2,:);ones(1,size(LS_Hull_c,2));LS_Hull_c(3:4,:);ones(1,size(LS_Hull_c,2))];

[artscores,a]=findDistancesNew(planes12,artline,ones(2)-eye(2),K);
threshAngleList=find(artscores>=cos(angleArtThresh*pi/180));
end