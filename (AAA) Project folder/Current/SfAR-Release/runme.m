%% Set up system environment
addpath(genpath('.'));              % Adding all subfolders to path
ccc;                                % Clear up everything
impath = 'data\office-and-hotel-building-275262_640.jpg';       % Set the path of the image
talk = getParameter('talk');        % Flag for internediate output
saveFig = getParameter('saveFig');  % Flag for saving figure
if ~exist(impath,'file')            % check if the image file exists
    error('Please enter a valid image path');
end
warning off all;                    % Turn off warnings
%% Main algorithm pipeline starts from here
tic;
[im,K,center,LS,LS_c,X,Ladj,hFig,L,inliers,numhyp,X3] = computeSegmentation(impath,talk);
toc;
% %% Save figures screeshot
% if saveFig
%     for i = 1:length(hFig)
%         name = [impath '_segmentation_' num2str(i) '_' get(hFig(1,i),'Name') '.jpg'];
%         print(hFig(i), '-djpeg', name);
%     end
% end
% %% Random testing / experiment code
% close all; clc;
% planeSeg = 2;
% A = inliers{1,planeSeg};
% c = simocost_HR(0,X(:,planeSeg),L,K,A,talk);

%% Old testing / developing code
% ******** Horizontal / Vertical assumption && Cost matrix ********
% [ar, ac] = find(A>0);
% root_name = 'C:\Users\NachoUTS\Desktop\saveData\Img';
% file_format = '.jpg';
% linewidth = 2;
% hFig = [];
% horzVector = [1,0];
% vertVector = [0,1];
% colour = {'red' 'cyan'};
% C = zeros(size(A,1));
% ax = X(3);
% ay = X(4);
% az = 0;
% R1 = makehgtform('xrotate',ax,'yrotate',ay); R1 = R1(1:3,1:3);
% R2 = makehgtform('zrotate', az); R2 = R2(1:3,1:3);
% Hinv = K * R1' * R2' * inv(K);
% Lp = Hinv' * L;
% Vp = Lp(1:2,:);
% Vp = Vp./repmat(sqrt(sum(Vp.^2)),2,1);
% for i=1:size(ar,1)
% %     hFig = [hFig az_fig];
% %     set(hFig(1,end),'Name','Original and Gap Filled Lines');
% %     imagesc(im), axis equal;
%     horzangle_L = dot(horzVector, abs(Vp(:,ar(i))));
%     vertangle_L = dot(vertVector, abs(Vp(:,ar(i))));
% %     hold on;
%     if(horzangle_L < vertangle_L)
%         disp('ar is probably aligned with Horizontal');
%         opcode = 1;
%         inplane_cost = (horzVector * Vp(:,ar(i)))^2 + (vertVector * Vp(:,ac(i)))^2;
%     else
%         disp('ar is probably aligned with Vertical');
%         opcode = 2;
%         inplane_cost = (vertVector * Vp(:,ar(i)))^2 + (horzVector * Vp(:,ac(i)))^2;
%     end
% 
%     C(ar(i), ac(i)) = inplane_cost;
% %     % Plot...for testing only
% %     plot(LS([1,3],ar(i)),LS([2,4],ar(i)),'-','color',colour{opcode},'linewidth',linewidth);
% %     plot(LS([1,3],ac(i)),LS([2,4],ac(i)),'-','color',colour{mod(opcode,2)+1},'linewidth',linewidth);
% %     % pause(2);
% %     hold off;
% % % %    Save figure
% % %     filename = [root_name, '_' num2str(i), file_format];
% % %     print(hFig(i), '-djpeg', filename);
% %      close;
% end
% c = sum(sum(C));

% ******** Show inliers line-pairs (no horz/vert categotise) ********
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

