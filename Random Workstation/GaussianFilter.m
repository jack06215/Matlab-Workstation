I = imread('TW Home Wifi.JPG');
%Filter the image with a Gaussian filter with standard deviation of 2.

Iblur = imgaussfilt(I);

subplot(1,2,1)
imshow(I)
title('Original Image');
subplot(1,2,2)
imshow(Iblur)
title('Gaussian filtered image, \sigma = 2')