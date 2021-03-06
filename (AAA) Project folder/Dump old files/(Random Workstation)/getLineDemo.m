clear, close all;
refFrm = imread('..\(Sample Images)\curFrm.png');
curFrm = imread('..\(Sample Images)\outImg.png');
refFrm_line = getLines(rgb2gray(refFrm), 40);
curFrm_line = getLines(rgb2gray(curFrm), 40);



%% Remove half of the feature points at LHS
row_del_index = removeSomeEntry(refFrm_line, refFrm);
refFrm_line(row_del_index,:) = [];
row_del_index = removeSomeEntry(curFrm_line, curFrm);
curFrm_line(row_del_index,:) = [];

curFrm_movingPts = vertcat(curFrm_line(:,[3,1]), curFrm_line(:,[4,2]));
refFrm_movingPts = vertcat(refFrm_line(:,[3,1]), refFrm_line(:,[4,2]));

csvwrite('..\(Sample Images)\refFrm_line.csv', refFrm_movingPts);
csvwrite('..\(Sample Images)\curFrm_line.csv', curFrm_movingPts);
%% Show result
figure;
imshow(refFrm), hold on;
title('Reference');
% plot(refFrm_line(:,3),refFrm_line(:,1),'o', 'Color', 'Red', 'LineWidth', 2);
% plot(refFrm_line(:,4),refFrm_line(:,2),'o', 'Color', 'Red', 'LineWidth', 2);
plot(refFrm_movingPts(:,1),refFrm_movingPts(:,2),'o', 'Color', 'Red', 'LineWidth', 2);

figure;
imshow(curFrm), hold on;
title('Reference');
plot(curFrm_movingPts(:,1),curFrm_movingPts(:,2),'o', 'Color', 'Red', 'LineWidth', 2);

% tform= estimateGeometricTransform(curFrm_movingPts,refFrm_movingPts,'similarity');

