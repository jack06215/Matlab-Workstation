% %% Set up system environment
% addpath(genpath('.'))               % Adding all subfolders to path
% ccc;                                % Clear up everything
% impath = 'data\DSC_0005.jpg';       % Set the path of the image
% talk = getParameter('talk');        % Flag for internediate output
% saveFig = getParameter('saveFig');  % Flag for saving figure
% if ~exist(impath,'file')            % check if the image file exists
%     error('Please enter a valid image path');
% end
% warning off all;                    % Turn off warnings
% %% Main algorithm pipeline starts from here
% tic;
% [im,K,center,LS,LS_c,X,Ladj,hFig,L,inliers] = computeSegmentation(impath,talk);
% toc;
% %% Save figures screeshot
% if saveFig
%     for i = 1:length(hFig)
%         name = [impath '_segmentation_' num2str(i) '_' get(hFig(1,i),'Name') '.jpg'];
%         print(hFig(i), '-djpeg', name);
%     end
% end
%% Random testing / experiment code
% % >>>>> Sample az_fig code to display imge with grid <<<<<<
% hFig=[hFig az_fig];
% set(hFig(1,end),'Name','Gap Filled and Extended Lines');
% imagesc(im), axis equal;
% >>>> Horizontal / Vertical assumption <<<<<
close all;
clc;

Ladj_triu = inliers{1,1};
[ar, ac] = find(Ladj_triu>0);
root_name = 'D:\saveData\Img';
file_format = '.jpg';
linewidth = 2;
hFig = [];
horzVector = [1,0];
vertVector = [0,1];
colour = {'red' 'cyan'};
for i=1:size(ar,1)
    hFig = [hFig az_fig];
    set(hFig(1,end),'Name','Original and Gap Filled Lines');
    imagesc(im), axis equal;
    DirVector3 = abs(LS([3,4],ar(i))' - LS([1,2],ar(i))');
    DirVector3 = DirVector3./[norm(DirVector3), norm(DirVector3)];
    horzangle = acos(dot(horzVector,DirVector3)/norm(horzVector)/norm(DirVector3));
    vertangle = acos(dot(vertVector,DirVector3)/norm(vertVector)/norm(DirVector3));
    hold on;
    if(horzangle < vertangle)
        disp('Horizontal');
        opcode = 1;
    else
        disp('Vertical');
        opcode = 2;
    end
    
    
    plot(LS([1,3],ar(i)),LS([2,4],ar(i)),'-','color',colour{opcode},'linewidth',linewidth);
    plot(LS([1,3],ac(i)),LS([2,4],ac(i)),'-','color',colour{mod(opcode,2)+1},'linewidth',linewidth);
    hold off;
    % Save figure
    filename = [root_name, '_' num2str(i), file_format];
    print(hFig(i), '-djpeg', filename);
    close;
end
% 
% for i=1:size(ar,1)
% %     figure(1), imshow(im);
% %     hold on;
%     hFig = [hFig az_fig];
%     set(hFig(1,end),'Name','Original and Gap Filled Lines');
%     imagesc(im), axis equal;
%     hold on
%     plot(LS([1,3],ar(i)),LS([2,4],ar(i)),'-','color','cyan','linewidth',linewidth);
%     plot(LS([1,3],ac(i)),LS([2,4],ac(i)),'-','color','red','linewidth',linewidth);
%     hold off;
%     filename = [root_name, '_' num2str(i), file_format];
%     print(hFig(i), '-djpeg', filename);
%     close;
% end

