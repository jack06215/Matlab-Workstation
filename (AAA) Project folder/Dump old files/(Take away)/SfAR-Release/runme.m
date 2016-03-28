% This script takes in an image path and outputs it's 3D structure.
% Please refer to the readme.
% You need to set the image path below.

%%
%Adding all subfolders to path
addpath(genpath('.'))
% clear up everything
ccc;
%set the path of the image
impath = 'data\IMG_7997.jpg';

talk = getParameter('talk');
saveFig = getParameter('saveFig');
%% Begin script
% check if the image file exists
if ~exist(impath,'file')
    error('Please enter a valid image path');
end

% turn off warnings
warning off all;
[im,K,center,LS,LS_c,goodquads,planes,rsegs,psegs,X,goodinds] = computeSegmentation(impath,talk);

[artlineinds,LS_Hull, LS_Hull_c] = computeArticulation( psegs,rsegs,im,goodquads,LS,LS_c,planes,center,K,impath,talk,saveFig );

[planes,im,H,pts,xp] = computeStructure(im,artlineinds,X,psegs,rsegs,goodinds,LS_c,LS_Hull_c,K,center,goodquads);

[fig Store] = getTextureMapping(planes,im,H,pts,center,xp);