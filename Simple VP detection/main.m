refImg = imread('dsc004901.jpg');
refImg_gray = rgb2gray(refImg);

figure;
imshow(refImg), hold on;
refImg_line = getLines(refImg_gray, 50);
% for i = 1:size(refImg_line,1)
%       plot(refImg_line(i, [1 2])', refImg_line(i, [3 4])', 'Color', 'Red', 'LineWidth', 2);
%      plot(refImg_line(i,1),refImg_line(i,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
%      plot(refImg_line(i,2),refImg_line(i,4),'x', 'Color', 'Green', 'LineWidth', 2);
% end
i = 1;
homo = cross(horzcat(refImg_line(i,[1,3]),1), horzcat(refImg_line(i,[2,4]),1));
