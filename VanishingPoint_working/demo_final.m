close all;
%% Read image and convert it to grayscale
refImg = imread('il_570xN.322640763.jpg');
currentImg = imread('../(Sample Images)/DSC_0765.JPG');
refImg_gray = rgb2gray(refImg);
currentImg_gray = rgb2gray(currentImg);

%refImg_vanishing = [-81.4361724384012,-1601.81105937697;497.985790050530,77.1980984241665;-462.116264039683,139.505995276970];
%currentImg_vanishing = [820.700439610719,97.6336727556712;-85.3786960482455,-1402.60904823873;-607.662423310135,-41.8854966622190];

%% Vanishing Point Detection
[refImg_lineSegment, refImg_vanishing, refImg_points, refImg_foc] = detectTOVP(refImg_gray);
[currentImg_lineSegment, currentImg_vanishing, currentImg_points, currentImg_foc] = detectTOVP(currentImg_gray);
refImg_movingPts = vertcat(refImg_lineSegment(:,[1,3]), refImg_lineSegment(:,[2,4]));
[ refImg_estimateMovingPts ] = triangleMeasure( refImg_movingPts, refImg_vanishing, currentImg_vanishing  );
%% Show Vanishing Point
figure;
imshow(refImg), hold on;
title('Previous');
% plot(refImg_lineSegment(:,1),refImg_lineSegment(:,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
% plot(refImg_lineSegment(:,2),refImg_lineSegment(:,4),'x', 'Color', 'Green', 'LineWidth', 2);
showTOVP( refImg, refImg_gray, refImg_vanishing, refImg_points, refImg_foc);

figure;
imshow(currentImg), hold on;
title('Current');
% plot(currentImg_lineSegment(:,1), currentImg_lineSegment(:,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
% plot(currentImg_lineSegment(:,2), currentImg_lineSegment(:,4),'x', 'Color', 'Green', 'LineWidth', 2);
showTOVP(currentImg, currentImg_gray, currentImg_vanishing, currentImg_points, currentImg_foc);
%% Triangulation Measurement
figure, hold on;
xlim([-3000,3000]);
ylim([-3000,3000]);
daspect([1 1 1]);
% Triangular formed by three vanishing points from REF
plot(refImg_vanishing(:,1), refImg_vanishing(:,2), 'x', 'Color', 'Green', 'MarkerSize', 15, 'LineWidth', 2);
plot([refImg_vanishing(1,1), refImg_vanishing(2,1)], [refImg_vanishing(1,2), refImg_vanishing(2,2)], '-', 'Color', 'Green', 'LineWidth', 2);
plot([refImg_vanishing(1,1), refImg_vanishing(3,1)], [refImg_vanishing(1,2), refImg_vanishing(3,2)], '-', 'Color', 'Green', 'LineWidth', 2);
plot([refImg_vanishing(2,1), refImg_vanishing(3,1)], [refImg_vanishing(2,2), refImg_vanishing(3,2)], '-', 'Color', 'Green', 'LineWidth', 2);
% Moving points bounded by vanishing points A
plot(refImg_movingPts(:,1), refImg_movingPts(:,2), '*', 'Color', 'Black', 'MarkerSize', 5, 'LineWidth', 1);


% Triangular formed by three vanishing points from CURRENT
plot(currentImg_vanishing(:,1), currentImg_vanishing(:,2), 'x', 'Color', 'Red', 'MarkerSize', 15, 'LineWidth', 2);
plot([currentImg_vanishing(1,1), currentImg_vanishing(2,1)], [currentImg_vanishing(1,2), currentImg_vanishing(2,2)], '-', 'Color', 'Red', 'LineWidth', 2);
plot([currentImg_vanishing(1,1), currentImg_vanishing(3,1)], [currentImg_vanishing(1,2), currentImg_vanishing(3,2)], '-', 'Color', 'Red', 'LineWidth', 2);
plot([currentImg_vanishing(2,1), currentImg_vanishing(3,1)], [currentImg_vanishing(2,2), currentImg_vanishing(3,2)], '-', 'Color', 'Red', 'LineWidth', 2);
% Moving points bounded by vanishing points B
plot(refImg_estimateMovingPts(:,1), refImg_estimateMovingPts(:,2), '*', 'Color', 'Cyan', 'MarkerSize', 5, 'LineWidth', 1);

% Show displacement trajectory
for i=1:size(refImg_movingPts,1)
    plot([refImg_movingPts(i,1), refImg_estimateMovingPts(i,1)], [refImg_movingPts(i,2), refImg_estimateMovingPts(i,2)], '-', 'Color', 'Blue', 'MarkerSize', 5, 'LineWidth', 1);
end

%% Estimate homography besed on moving points
[tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(refImg_movingPts, refImg_estimateMovingPts, 'projective');
outImg = imwarp(refImg, tform);
figure;
imshow(outImg);
title('Warp');

