%% Set up system environment
addpath(genpath('.'))               % Adding all subfolders to path
ccc;                                % Clear up everything
impath = 'data\DSC_0013.jpg';       % Set the path of the image
talk = getParameter('talk');        % Flag for internediate output
saveFig = getParameter('saveFig');  % Flag for saving figure
if ~exist(impath,'file')            % check if the image file exists
    error('Please enter a valid image path');
end
warning off all;                    % Turn off warnings
%% Main algorithm pipeline starts from here
tic;
[im,K,center,LS,LS_c,X,Ladj,hFig,L] = computeSegmentation(impath,talk);
toc;
%% Save figures screeshot
if saveFig
    for i = 1:length(hFig)
        name = [impath '_segmentation_' num2str(i) '_' get(hFig(1,i),'Name') '.jpg'];
        print(hFig(i), '-djpeg', name);
    end
end
%% Random testing / experiment code
hFig=[hFig az_fig];
set(hFig(1,end),'Name','Gap Filled and Extended Lines');
imagesc(im), axis equal;
