close all;
addpath(genpath('.'));
%% Read image and convert it to grayscale
img = imread('data/Garfield_Building_Detroit.jpg');
img_gray = rgb2gray(img);
%% Vanishing Point Detection
[img_ls, img_vp, img_intsectPts, img_foc] = detectTOVP(img_gray);
%% Midpoint of line segments
img_lsMidPts = zeros(size(img_ls,1),2);
for i=1:size(img_ls,1)
    img_lsMidPts(i,1) = (img_ls(i,1) + img_ls(i,2)) / 2;
    img_lsMidPts(i,2) = (img_ls(i,3) + img_ls(i,4)) / 2;
end
%% Show Vanishing Point

showTOVP( img, img_gray, img_vp, img_intsectPts, img_foc);
%% Experiment code
% End point and midpoint
img_ls_sorted = [img_ls(:,[2,4]),img_lsMidPts];
img_ls_label = zeros(size(img_ls,1),1);
diatance_vp = Inf(1,3);
color = {'Red', 'Cyan', 'Yellow'};
for i=1:size(img_ls_sorted,1)
    for j=1:3
        A = (img_lsMidPts(i,2) - (img_vp(j,2) + size(img_gray,1)/2))/(img_lsMidPts(i,1) - (img_vp(j,1)+size(img_gray,2)/2));
        B = -1;
        C = ((img_vp(j,2) + size(img_gray,1)/2) - A * (img_vp(j,1) + size(img_gray,2)/2));
        diatance_vp(j) = (A*img_ls(i,2) + B*img_ls(i,4) + C)/(sqrt(A*A + B*B));
    end
    [~,B] = min(abs(diatance_vp));
    img_ls_label(i) = B;
end

figure;
imshow(img), hold on;
title('Result');
for i=1:size(img_ls,1)
    plot(img_ls(i,[1,2]),img_ls(i,[3,4]), '-', 'Color', color{img_ls_label(i)}, 'LineWidth', 2);
end