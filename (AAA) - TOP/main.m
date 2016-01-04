clear, close all;
curFrm = imread('..\(Sample Images)\DSC_0765.JPG'); % Current frame 
modelFrm = imread('..\(Sample Images)\DSC_0764.JPG'); % Model frame (to be mapped)
% curFrm = imread('..\(Sample Images)\outImg.png'); % Current frame 
% modelFrm = imread('..\(Sample Images)\DSC_0761.JPG'); % Model frame (to be mapped)
%% VP Detection, grabbed from below implementation
% Vanishing Point Detection Using 1D Histogram by Dividing Image Plane into Interior and Exterior Regions
% Author:	Bo Li, Kun Peng, Xianghua Ying, Hongbin Zha
% Contact:	pkusoil@gmail.com
[modelFrm_line, modelFrm_vp] = IER_VPDetection(modelFrm);
[curFrm_line, curFrm_vp] = IER_VPDetection(curFrm);
%% Draw line segment & VP result
figure;
imshow(modelFrm);
title('Model');

figure;
imshow(curFrm);
title('Current Frame');

draw(modelFrm,modelFrm_vp,zeros(3),modelFrm_line);
draw(curFrm,curFrm_vp,zeros(3),curFrm_line);


%% Triamgule measure & warping
modelFrm_points = vertcat(modelFrm_line(:,[3,1]), modelFrm_line(:,[4,2]));
[modelFrm_estimatePoints] = triangleMeasure(modelFrm_points, modelFrm_vp, curFrm_vp);

[tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(modelFrm_points, modelFrm_estimatePoints, 'projective');
model_distored = imwarp(modelFrm, tform);
%% Show the warping result
figure;
imshow(model_distored);
title('Distored model');

figure; showMatchedFeatures(modelFrm,curFrm,inlierPtsOriginal,inlierPtsDistorted);
title('Matched inlier points');
% imwrite(curFrm, '..\(Sample Images)\curFrm.png');
% imwrite(outImg, '..\(Sample Images)\outImg.png');