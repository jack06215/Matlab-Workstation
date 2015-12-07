refImg = imread('DSC_0764.jpg');
currentImg = imread('DSC_0765.JPG');
refImg_gray = rgb2gray(refImg);
currentImg_gray = rgb2gray(currentImg);
[refImg_lineSegment, refImg_vanishing, refImg_points, refImg_foc] = detectTOVP(refImg_gray);
[currentImg_lineSegment, currentImg_vanishing, currentImg_points, currentImg_foc] = detectTOVP(currentImg_gray);

figure;
imshow(refImg), hold on;
plot(refImg_lineSegment(:,1),refImg_lineSegment(:,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
plot(refImg_lineSegment(:,2),refImg_lineSegment(:,4),'x', 'Color', 'Green', 'LineWidth', 2);
showTOVP( refImg, refImg_gray, refImg_vanishing, refImg_points, refImg_foc);

figure;
imshow(currentImg), hold on;
plot(currentImg_lineSegment(:,1), currentImg_lineSegment(:,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
plot(currentImg_lineSegment(:,2), currentImg_lineSegment(:,4),'x', 'Color', 'Yellow', 'LineWidth', 2);
showTOVP(currentImg, currentImg_gray, currentImg_vanishing, currentImg_points, currentImg_foc);