close all;
ImgA = imread('Sample Images\fig2.jpg');
ImgB = imread('Sample Images\fig2.jpg');
difference = 100;

point_i = [0,0;
           0, size(ImgB, 1);
           size(ImgB, 2), 0;
           size(ImgB, 2), size(ImgB, 1)];
point_iPrime = [0,0;
                0, size(ImgB, 1);
                size(ImgB, 2) - difference, 0 + difference;
                size(ImgB, 2) - difference, size(ImgB, 1) - difference];
            
tform = estimateGeometricTransform(point_i, point_iPrime, 'projective');

ImgB = imwarp(ImgB, tform);
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