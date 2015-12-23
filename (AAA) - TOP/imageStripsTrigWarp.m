close all;
ImgA = imread('..\(Sample Images)\curFrm.png');
ImgB = imread('..\(Sample Images)\outImg.png');
yy = 0;
point_i = [328,251;322,301;456 + size(ImgA,2) / 2,186 + size(ImgA,1) / 2];
point_iPrime = [441,309;437,353; 578 + size(ImgB,2) / 2, 203 + size(ImgB,1) / 2];      

ImgA_ls = getLines(rgb2gray(ImgA), 40);
ImgB_ls = getLines(rgb2gray(ImgB), 40);


figure, imshow(ImgA), hold on;
axis([-500 1000 -500 1000]);
plot(point_i(:,1), point_i(:,2), '*', 'Color', 'Red');
plot(ImgA_ls(:,3),ImgA_ls(:,1),'x', 'Color', 'Yellow', 'LineWidth', 2);
plot(ImgA_ls(:,4),ImgA_ls(:,2),'x', 'Color', 'Green', 'LineWidth', 2);
title(['REF::dim: ', num2str(size(ImgA, 1)), ' x ', num2str(size(ImgA, 2))]);

figure, imshow(ImgB), hold on;
axis([-500 1000 -500 1000]);
plot(point_iPrime(:,1), point_iPrime(:,2), '*', 'Color', 'Red');
plot(ImgB_ls(:,3),ImgB_ls(:,1),'x', 'Color', 'Yellow', 'LineWidth', 2);
plot(ImgB_ls(:,4),ImgB_ls(:,2),'x', 'Color', 'Green', 'LineWidth', 2);
title(['TARGET::dim: ', num2str(size(ImgB, 1)), ' x ', num2str(size(ImgB, 2))]);

% %% Warping
% tform = estimateGeometricTransform(point_i, point_iPrime, 'affine');
% ImgB = imwarp(ImgB, tform);
% 
% figure, imshow(ImgB);
% title(['dim: ', num2str(size(ImgB, 1)), ' x ', num2str(size(ImgB, 2))]);
% 
% 
% %% Combine two image into one
% % Zero-fill the image if their dimension are not equal
% iwidth = max(size(ImgA, 2), size(ImgB, 2));
% if (size(ImgA, 2) < iwidth)
%     ImgA(1,iwidth, 1) = 0;
% end
% if (size(ImgB, 2) < iwidth)
%     ImgB(1, iwidth, 1) = 0;
% end
% 
% iheight = max(size(ImgA, 1), size(ImgB, 1));
% if (size(ImgA, 1) < iheight)
%     ImgA(iheight, end, 1) = 0;
% end
% if (size(ImgB, 1) < iheight)
%     ImgB(iheight, end, 1) = 0;
% end
% newImg = cat(2, ImgA, ImgB);
% 
% figure, imshow(newImg);
% title(['dim: ', num2str(size(newImg, 1)), ' x ', num2str(size(newImg, 2))]);