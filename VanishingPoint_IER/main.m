clear, close all;
refFrm = imread('Test Images\BuildingA_original.png');
curFrm = imread('Test Images\DSC_0782.png');

%% Line segment + VP detection
refFrm_line = getLines(rgb2gray(refFrm), 40);
curFrm_line = getLines(rgb2gray(curFrm), 40);
refFrm_vp = getVP3(refFrm_line, size(refFrm, 1), size(refFrm, 2));
curFrm_vp = getVP3(curFrm_line, size(curFrm, 1), size(curFrm, 2));

%% Sort out VP order that vertex has the same order
% Top -> RHS -> LHS
% real VP location = [v1x, v2x, v3x] + width / 2 && 
%                    [v1y, v2y, v3y] + height / 2
% When v[i]z = 0, that means it has its VP is at inf.
% Swap row i and j ==> matA([i,j],:) = matA([j,i],:)
% Swap col i and j ==> matA(:,[i,j]) = matA(:,[j,i])
% Find index..(j) and value..(i) of max value from 2 col ==> [i, j] = max(matA(:,2))

% 1st elememt for TOP
[~, swapIdx] = min(refFrm_vp(:,2));
refFrm_vp([1, swapIdx],:) = refFrm_vp([swapIdx, 1],:);
[~, swapIdx] = min(curFrm_vp(:,2));
curFrm_vp([1, swapIdx],:) = curFrm_vp([swapIdx, 1],:);

% 2nd element for RHS AND % 3rd element for LHS
if (refFrm_vp(2,1) > refFrm_vp(3,1))
    refFrm_vp([2, 3],:) = refFrm_vp([3, 2],:);
end

if (curFrm_vp(2,1) > curFrm_vp(3,1))
    curFrm_vp([2, 3],:) = curFrm_vp([3, 2],:);
end
%% Draw line segment & VP result
figure;
imshow(refFrm);
title('REF');
% plot(refFrm_line(:,3),refFrm_line(:,1),'x', 'Color', 'Yellow', 'LineWidth', 2);
% plot(refFrm_line(:,4),refFrm_line(:,2),'x', 'Color', 'Green', 'LineWidth', 2);
% for i = 1:size(refFrm_line,1)
%     plot([refFrm_line(i,3), refFrm_line(i,4)], [refFrm_line(i,1), refFrm_line(i,2)], '-', 'Color', 'Blue');
% end
draw(refFrm,refFrm_vp,zeros(3),refFrm_line);
% 
figure;
imshow(curFrm);
title('CUR');
% plot(curFrm_line(:,3),curFrm_line(:,1),'x', 'Color', 'Yellow', 'LineWidth', 2);
% plot(curFrm_line(:,4),curFrm_line(:,2),'x', 'Color', 'Green', 'LineWidth', 2);
% for i = 1:size(curFrm_line,1)
%     plot([curFrm_line(i,3), curFrm_line(i,4)], [curFrm_line(i,1), curFrm_line(i,2)], '-', 'Color', 'Blue');
% end
draw(curFrm,curFrm_vp,zeros(3),curFrm_line);
% 
%% Triamgule measurement method
refFrm_movingPts = vertcat(refFrm_line(:,[3,1]), refFrm_line(:,[4,2]));
[refFrm_estimateMovingPts] = triangleMeasure(refFrm_movingPts, refFrm_vp, curFrm_vp);

[tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(refFrm_movingPts, refFrm_estimateMovingPts, 'projective');
outImg = imwarp(refFrm, tform);
figure;
imshow(outImg);
title('Warp');