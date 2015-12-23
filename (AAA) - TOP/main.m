clear, close all;
curFrm = imread('..\(Sample Images)\DSC_0765.JPG');
refFrm = imread('..\(Sample Images)\outImg.png');
%% VP Detection, grabbed from below implementation
% Vanishing Point Detection Using 1D Histogram by Dividing Image Plane into Interior and Exterior Regions
% Author:	Bo Li, Kun Peng, Xianghua Ying, Hongbin Zha
% Contact:	pkusoil@gmail.com
[refFrm_line, refFrm_vp] = IER_VPDetection(refFrm);
[curFrm_line, curFrm_vp] = IER_VPDetection(curFrm);
%% Draw line segment & VP result
figure;
imshow(refFrm);
title('REF');
draw(refFrm,refFrm_vp,zeros(3),refFrm_line);
figure;
imshow(refFrm);
title('CUR');
draw(curFrm,curFrm_vp,zeros(3),curFrm_line);
%% Triamgule measure & warping
refFrm_movingPts = vertcat(refFrm_line(:,[3,1]), refFrm_line(:,[4,2]));
[refFrm_estimateMovingPts] = triangleMeasure(refFrm_movingPts, refFrm_vp, curFrm_vp);

[tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(refFrm_movingPts, refFrm_estimateMovingPts, 'projective');
outImg = imwarp(refFrm, tform);
%% Show the warping result
figure;
imshow(outImg);
title('Warp result');
% imwrite(curFrm, '..\(Sample Images)\curFrm.png');
% imwrite(outImg, '..\(Sample Images)\outImg.png');