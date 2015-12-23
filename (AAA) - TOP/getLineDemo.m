clear, close all;
refFrm = imread('..\(Sample Images)\outImg.png');
frm_line = getLines(rgb2gray(refFrm), 40);
figure;
imshow(refFrm), hold on;
title('Current');
plot(frm_line(:,3),frm_line(:,1),'x', 'Color', 'Yellow', 'LineWidth', 2);
plot(frm_line(:,4),frm_line(:,2),'x', 'Color', 'Green', 'LineWidth', 2);