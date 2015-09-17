clc;
clear;
% Read in an image
imgRaw = imread('Sample Images\SimpleRect.JPG');
subplot(2, 2, 1);
imshow(imgRaw, 'InitialMagnification', 'fit');
title('Original image');
imgCvt = rgb2gray(imgRaw); % mexopencv equivelance is " cv.cvtColor(imgRaw, 'RGB2GRAY') "

% Calculate the DFT
PAD = paddedsize(size(imgCvt), 'PWR2');
imgFreqDomain = fft2(imgCvt, PAD(1), PAD(2));
%imgFreqDomain = fft2(imgCvt);
% abs() calculate the complex magnitude
% logTransform2D() to reduce the dynamic range after transfomration
imgOut = abs(imgFreqDomain);
imgOut = logTransform2D(imgOut, 0.5);
subplot(2, 2, 2);
imshow(imgOut, [], 'InitialMagnification', 'fit');
title('DFT, LogTransform, no shift');

% The zero-frequency coefficient is displayed in the upper left hand corner. 
% To display it in the center, you can use the function fftshift.
imgOut = fftshift(imgFreqDomain);
imgOut = abs(imgOut);
imgOut = logTransform2D(imgOut, 0.5);
subplot(2, 2, 3);
imshow(imgOut, [], 'InitialMagnification', 'fit');
title('DFT, LogTransform, after shift');

figure;
%subplot(2, 2, 4);
surf(imgOut);
rotate3d on, xlabel('width'), ylabel('height'), title('DFT result, after shift');

