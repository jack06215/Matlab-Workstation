clear, close all;
refFrm = imread('..\(Sample Images)\curFrm.png');
curFrm = imread('..\(Sample Images)\outImg.png');
refFrm_line = getLines(rgb2gray(refFrm), 40);
curFrm_line = getLines(rgb2gray(curFrm), 40);



row_del_index = removeSomeEntry(refFrm_line, refFrm);
refFrm_line(row_del_index,:) = [];
row_del_index = removeSomeEntry(curFrm_line, curFrm);
curFrm_line(row_del_index,:) = [];


figure;
imshow(refFrm), hold on;
title('Reference');
plot(refFrm_line(:,3),refFrm_line(:,1),'o', 'Color', 'Red', 'LineWidth', 2);
plot(refFrm_line(:,4),refFrm_line(:,2),'o', 'Color', 'Red', 'LineWidth', 2);

figure;
imshow(curFrm), hold on;
title('Reference');
plot(curFrm_line(:,3),curFrm_line(:,1),'o', 'Color', 'Red', 'LineWidth', 2);
plot(curFrm_line(:,4),curFrm_line(:,2),'o', 'Color', 'Red', 'LineWidth', 2);
