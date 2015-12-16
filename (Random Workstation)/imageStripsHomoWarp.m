close all;
ImgA = imread('DSC_0765.JPG');
ImgB = imread('DSC_0764.JPG');
yy = 500;
point_i = [330.419137466307,258.128032345013;345.082210242588,260.715633423180;324.381401617251,300.392183288410;343.357142857143,302.979784366577];   
point_iPrime = [346,248;366,249;349,296;369,294];        
tform = estimateGeometricTransform(point_i, point_iPrime, 'affine');
figure, imshow(ImgA), hold on;
plot(point_i(:,1), point_i(:,2), '*', 'Color', 'Red');
title(['dim: ', num2str(size(ImgA, 1)), ' x ', num2str(size(ImgA, 2))]);
figure, imshow(ImgB), hold on;
plot(point_iPrime(:,1), point_iPrime(:,2), '*', 'Color', 'Red');
title(['dim: ', num2str(size(ImgB, 1)), ' x ', num2str(size(ImgB, 2))]);
ImgB = imwarp(ImgB, tform);
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