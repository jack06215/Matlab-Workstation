%% Set up system environment
addpath(genpath('.'));              % Adding all subfolders to path
ccc;                                % Clear up everything
impath = 'data\Industrial_Building.jpg';       % Set the path of the image
talk = getParameter('talk');        % Flag for internediate output
saveFig = getParameter('saveFig');  % Flag for saving figure
if ~exist(impath,'file')            % check if the image file exists
    error('Please enter a valid image path');
end
warning off all;                    % Turn off warnings
%% Main algorithm pipeline starts from here
tic;
[im,K,center,LS,LS_c,X,Ladj,hFig,L,inliers,numhyp,X3] = computeSegmentation(impath,talk);
% [im_new,hFig] = obtainFrontalView(im,K,X3,center,hFig,1);
toc;
%% Save figures screeshot
if saveFig
    for i = 1:length(hFig)
        name = [impath '_segmentation_' num2str(i) '_' get(hFig(1,i),'Name') '.jpg'];
        print(hFig(i), '-djpeg', name);
    end
end