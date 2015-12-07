refImg = imread('Sample Images\DSC_0764.JPG');
currentImg = imread('Sample Images\DSC_0765.JPG');

refImg_original = refImg;
currentImg_original = currentImg;

refImg = rgb2gray(refImg);
currentImg = rgb2gray(currentImg);

refImg_line = getLines(refImg,50);
currentImg_line = getLines(currentImg, 50);

figure;
imshow(refImg_original), hold on;
for i = 1:size(refImg_line,1)
     %plot(line(i, [1 2])', line(i, [3 4])', 'Color', 'Red', 'LineWidth', 2);
     plot(refImg_line(i,1),refImg_line(i,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
     plot(refImg_line(i,2),refImg_line(i,4),'x', 'Color', 'Green', 'LineWidth', 2);
     %pause(0.01);
end

figure;
imshow(currentImg_original), hold on;
for i = 1:size(currentImg_line,1)
     %plot(line(i, [1 2])', line(i, [3 4])', 'Color', 'Red', 'LineWidth', 2);
     plot(currentImg_line(i,1),currentImg_line(i,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
     plot(currentImg_line(i,2),currentImg_line(i,4),'x', 'Color', 'Green', 'LineWidth', 2);
     %pause(0.01);
end

[refImg_vanishing, refImg_point, refImg_foc] = detectVanishingPoint(refImg_original, refImg, refImg_line);
[currentImg_vanishing, currentImg_point, currentImg_foc] = detectVanishingPoint(currentImg_original, currentImg, currentImg_line);
drawVanishingPoint( refImg_original, refImg, refImg_vanishing, refImg_point, refImg_foc );
drawVanishingPoint( currentImg_original, currentImg, currentImg_vanishing, currentImg_point, currentImg_foc );
% movingPtsA = vertcat(currentImg_line(:,[1,3]), currentImg_line(:,[2,4]));
% [ movingPtsB ] = triangleMeasure( movingPtsA, refImg_vanishing, currentImg_vanishing  );
% [tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(movingPtsA, movingPtsB, 'affine');
% figure(2);
% showMatchedFeatures(currentImg_original, refImg_original,...
%                     inlierPtsOriginal, inlierPtsDistorted, 'Montage');