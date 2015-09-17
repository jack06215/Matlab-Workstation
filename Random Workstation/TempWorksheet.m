clc;
clear;
% Read in an image
imgRaw = imread('Sample Images\SimpleRect.JPG');
subplot(2, 2, 1);
imshow(imgRaw, 'InitialMagnification', 'fit');
title('Original image');
