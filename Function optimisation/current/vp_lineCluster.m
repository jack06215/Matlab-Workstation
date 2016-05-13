%VP_LINECLUSTER - Line Segment Clustering based on 3 Vanishing Point
% Given an input image, it will perform line detection and furthermore
% categorised them according to the closest three orthogonal vanishing 
% points (TOVP).
%--------------------------------------------------------------------------
%   INPUT
%       img_gray  - Grayscale image.
%       ls_center - 4xn of centered line segment defined by two end
%                   points.
%       K         - 3x3 of camera intrnsic without image center infromation.
%   OUTPUT
%       x         - 1x2 of final result of estimate angle alpha and beta.
%--------------------------------------------------------------------------

function [img_ls,img_ls_center,img_ls_label,img_vp] = vp_lineCluster(img_gray,center,ls_threshold)
%% Vanishing Point Detection
[~, img_vp] = detectTOVP(img_gray);
if nargin < 3 
    ls_threshold = 40;
    warning('ls_threshold is set to default value of 40');
end
% Re-arrange the VP order {TOP,RHS,LSH}
% 1st elememt for TOP
[~, swapIdx] = min(img_vp(:,2));
img_vp([1, swapIdx],:) = img_vp([swapIdx, 1],:);
% 2nd element for RHS AND % 3rd element for LHS
if (img_vp(2,1) > img_vp(3,1))
    img_vp([2, 3],:) = img_vp([3, 2],:);
end

img_ls = getLines(img_gray,ls_threshold);

%% Midpoint of line segments
img_lsMidPts = zeros(size(img_ls,1),2);
for i=1:size(img_ls,1)
    img_lsMidPts(i,1) = (img_ls(i,1) + img_ls(i,2)) / 2;
    img_lsMidPts(i,2) = (img_ls(i,3) + img_ls(i,4)) / 2;
end
%% Experiment code
% End point and midpoint
img_ls_sorted = [img_ls(:,[2,4]),img_lsMidPts];
img_ls_label = zeros(size(img_ls,1),1);
diatance_vp = Inf(1,3);
for i=1:size(img_ls_sorted,1)
    for j=1:3
        A = (img_lsMidPts(i,2) - (img_vp(j,2) + size(img_gray,1)/2))/(img_lsMidPts(i,1) - (img_vp(j,1)+size(img_gray,2)/2));
        B = -1;
        C = ((img_vp(j,2) + size(img_gray,1)/2) - A * (img_vp(j,1) + size(img_gray,2)/2));
        diatance_vp(j) = (A*img_ls(i,2) + B*img_ls(i,4) + C)/(sqrt(A*A + B*B));
    end
    [~,B] = min(abs(diatance_vp));
    img_ls_label(i) = B;
end
img_ls = img_ls(:,1:4)';
img_ls = [img_ls(1,:); img_ls(3,:); img_ls(2,:); img_ls(4,:)];
img_ls_center = img_ls - repmat(center,2,size(img_ls,2));
end

