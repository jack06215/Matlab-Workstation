%% Program Summary:
% 1. Perform Line segment detection on image
% 2. Take the end-points of line segment and VP, plot them on interface
% 3. Use "triangle measureme"nt method to eatimate a new set of end-points
%    transformation
% 4. Use MATLAB function estimateGeometricTransform() to obtain H
%    parameter, then perform warping

%% Step 0 - Data initialisation and preparasion
close all;

% Read image from file
curFrm = imread('..\(Sample Images)\curFrm.png');
outImg = imread('..\(Sample Images)\outImg.png');
outImg_orig = imread('..\(Sample Images)\DSC_0764.JPG');

% Two manually chosen + VP points
curFrm_VP = [328,251; 322,301; 
             456 + size(curFrm,2) / 2, 186 + size(curFrm,1) / 2];
        
outImg_VP = [441,309; 437,353; 578 + size(outImg,2) / 2, 203 + size(outImg,1) / 2];      

%% Strp 1 - LSD 
curFrm_pts = csvread('..\(Sample Images)\refFrm_line.csv');
outImg_pts = csvread('..\(Sample Images)\curFrm_line.csv');
figure, imshow(curFrm);

%% Step 2 - Plotting point information on interface
figure, imshow(curFrm), hold on;
axis([0 1000 -500 1000]);
plot(curFrm_VP(:,1), curFrm_VP(:,2), '*', 'Color', 'Cyan');
% plot(curFrm_pts(:,3),curFrm_pts(:,1),'x', 'Color', 'Yellow', 'LineWidth', 2);
% plot(curFrm_pts(:,4),curFrm_pts(:,2),'x', 'Color', 'Green', 'LineWidth', 2);
% plot(curFrm_pts(:,1),curFrm_pts(:,2),'o', 'Color', 'Red', 'LineWidth', 2);
title(['REF::dim: ', num2str(size(curFrm, 1)), ' x ', num2str(size(curFrm, 2))]);

figure, imshow(outImg), hold on;
axis([0 1000 -500 1000]);
plot(outImg_VP(:,1), outImg_VP(:,2), '*', 'Color', 'Cyan');
% plot(outImg_pts(:,3),outImg_pts(:,1),'x', 'Color', 'Yellow', 'LineWidth', 2);
% plot(outImg_pts(:,4),outImg_pts(:,2),'x', 'Color', 'Green', 'LineWidth', 2);
plot(outImg_pts(:,1),outImg_pts(:,2),'o', 'Color', 'Red', 'LineWidth', 2);
title(['TARGET::dim: ', num2str(size(outImg, 1)), ' x ', num2str(size(outImg, 2))]);


%% Plot Triangle on another graph
% We want to map the  points w.r.t. the green trangle boundary
figure, hold on;
daspect([1,1,1]);
xlim([100,1000]);
ylim([100,500]);

plot([curFrm_VP(1,1), curFrm_VP(2,1)], [curFrm_VP(1,2), curFrm_VP(2,2)], '-', 'Color', 'Green', 'LineWidth', 2);
plot([curFrm_VP(1,1), curFrm_VP(3,1)], [curFrm_VP(1,2), curFrm_VP(3,2)], '-', 'Color', 'Green', 'LineWidth', 2);
plot([curFrm_VP(2,1), curFrm_VP(3,1)], [curFrm_VP(2,2), curFrm_VP(3,2)], '-', 'Color', 'Green', 'LineWidth', 2);

plot([outImg_VP(1,1), outImg_VP(2,1)], [outImg_VP(1,2), outImg_VP(2,2)], '-', 'Color', 'Red', 'LineWidth', 2);
plot([outImg_VP(1,1), outImg_VP(3,1)], [outImg_VP(1,2), outImg_VP(3,2)], '-', 'Color', 'Red', 'LineWidth', 2);
plot([outImg_VP(2,1), outImg_VP(3,1)], [outImg_VP(2,2), outImg_VP(3,2)], '-', 'Color', 'Red', 'LineWidth', 2);

[modelFrm_estimatePoints] = triangleMeasure(outImg_pts, outImg_VP, curFrm_VP);

%% Warping
tform = estimateGeometricTransform(outImg_pts, modelFrm_estimatePoints, 'affine');
ImgB = imwarp(outImg, tform);
% 
figure, imshow(ImgB);
figure, imshow(outImg_orig);
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