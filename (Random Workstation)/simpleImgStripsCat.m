close all;
ImgA = imread('Sample Images\fig1.jpg');
ImgB = imread('Sample Images\fig1.jpg');

warpMat = [0.8,-0.7,0;
           0.6,0.6,0;
           0,0,1]';
tMake = projective2d(warpMat);
ImgB = imwarp(ImgB, tMake);
figure, imshow(ImgA);
title(['dim: ', num2str(size(ImgA, 1)), ' x ', num2str(size(ImgA, 2))]);
figure, imshow(ImgB);
title(['dim: ', num2str(size(ImgB, 1)), ' x ', num2str(size(ImgB, 2))]);
%% Zero-fill the image if their dimension are not equal
iwidth = max(size(ImgA, 2), size(ImgB, 2));
if (size(ImgA, 2) < iwidth)
    ImgA(1,iwidth, 1) = 0;
end
if (size(ImgB, 2) < iwidth)
    ImgB(1, iwidth, 1) = 0;
end

iheight = max(size(ImgA, 1), size(ImgB, 1));
if (size(ImgA, 1) < iheight)
    ImgA(iheight, end, 1) = 0;
end
if (size(ImgB, 1) < iheight)
    ImgB(iheight, end, 1) = 0;
end
newImg = cat(2, ImgA, ImgB);

figure, imshow(newImg);
title(['dim: ', num2str(size(newImg, 1)), ' x ', num2str(size(newImg, 2))]);