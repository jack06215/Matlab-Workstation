%% Program Initialisation
addpath(genpath('.'));
ccc;
%% Waiting for user input
im = imread('DSC_0760.JPG');
objImg = imread('Google.jpg');
figure;
imshow(im);
hold on;
[lsX, lsY] = getpts;    % Get points from user select
hold off;
close;
%% Pre-defined parameters from previous program
% Image center
center = [size(im,2)/2; size(im,1)/2];

% Camera intrinsic
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];

% Rotation parameter on each hypothesis plane
X = [0.144172003541432,0.161887680849420,-0.099848173348471,0.138800848766926;
    -0.776721177515494,0.719557697158842,1.123899011861867,-0.804358007244892];

% Homography parameter back to frontal-view
ax = X(1,1);ay=X(2,1);
R = makehgtform('xrotate',ax,'yrotate',ay); R=R(1:3,1:3);
H = K*R*inv(K);
%% Line boundary defined by users in the format of [x1,y1;x2,y2]
% 1st Line Segment
ls1 = [lsX(1); lsY(1); lsX(2); lsY(2)];     
ls1_C = ls1 - repmat(center, 2, size(ls1, 2));  % Center subtracted

% 2nd line segment
ls2 = [lsX(3); lsY(3); lsX(2); lsY(2)];
ls2_C = ls2 - repmat(center, 2, size(ls2, 2));  % Center subtracted

lineSeg = [ls1, ls2];
lineSeg_C = [ls1_C, ls2_C];                     % Center subtracted

% Construct line equation from the line segment defined 
lv1 = twopts2L(ls1_C);
lv2 = twopts2L(ls2_C);

lv = [lv1, lv2];
%% Construct quadraliteral based on user defined input
% Find intersection between two lines
intpt = az_hcross(lv1,lv2); intpt = intpt(1:2); 

% Column vector of line segments + point of interection in homogenous
% coordinate
pts = [[ls1_C(1:2),ls1_C(3:4),ls2_C(1:2),ls2_C(3:4),intpt];[1,1,1,1,1]];

% Apply homography and normalise, to w=1
ptsp = H*pts; ptsp=ptsp(1:2,:)./[ptsp(3,:);ptsp(3,:)];

% Line segments & point ofinterection in its frontal-view
ls1p = [ptsp(:,1);ptsp(:,2)];
ls2p = [ptsp(:,3);ptsp(:,4)];
intptp = ptsp(:,5);

%% Compute the "4th" points that forms a quadraliteral
pt11p = ls2p(1:2)+(ls1p(1:2)-intptp);
pt11 = inv(H)*[pt11p;1]; pt11=pt11(1:2)/pt11(3);

% Plus center
pt11_C = floor(pt11 + center);
intpt = intpt + center;
figure, imshow(im);
hp = impixelinfo;
set(hp,'Position',[5 1 300 20]);
%% Compute Homography for image augmentation onto current plane
scenePts = [ls1(1), pt11_C(1), intpt(1), ls2(1); ls1(2), pt11_C(2), intpt(2), ls2(2)];
objPts = [0,size(objImg,2),0,size(objImg,2); 0,0,size(objImg,1), size(objImg,1)];
H_img = findHomography(objPts, scenePts);
%% Show some manually choosen points ans LS
hold on;
plot(pt11_C(1), pt11_C(2), '*', 'Color', 'magenta', 'LineWidth', 3);
plot(ls1(1), ls1(2), '*', 'Color', 'Cyan', 'LineWidth', 3);
plot(ls2(1), ls2(2), '*', 'Color', 'Cyan', 'LineWidth', 3);
plot(intpt(1), intpt(2), '*', 'Color', 'Cyan', 'LineWidth', 3);

plot([pt11_C(1), ls1(1)], [pt11_C(2), ls1(2)], 'Color', 'Red', 'LineWidth', 3);
plot([pt11_C(1), ls2(1)], [pt11_C(2), ls2(2)], 'Color', 'Red', 'LineWidth', 3);
plot([intpt(1), ls2(1)], [intpt(2), ls2(2)], 'Color', 'Yellow', 'LineWidth', 3);
plot([intpt(1), ls1(1)], [intpt(2), ls1(2)], 'Color', 'Blue', 'LineWidth', 3);
hold off;

%% Warping
tform = projective2d(H');
im_warp = imwarp(im, tform);
im_warp2 = my_imwarp(im, H);
%% Show the plot of line segment mapping relation
figure, hold on,
% Original view
plot(pt11_C(1), pt11_C(2), 'x', 'Color', 'magenta', 'LineWidth', 3);
plot(ls1(1), ls1(2), '*', 'Color', 'Green', 'LineWidth', 1);
plot(ls2(1), ls2(2), '*', 'Color', 'Green', 'LineWidth', 1);
plot(intpt(1), intpt(2), '*', 'Color', 'Green', 'LineWidth', 1);

plot([pt11_C(1), ls1(1)], [pt11_C(2), ls1(2)], 'Color', 'Red', 'LineWidth', 1);
plot([pt11_C(1), ls2(1)], [pt11_C(2), ls2(2)], 'Color', 'Red', 'LineWidth', 1);
plot([intpt(1), ls2(1)], [intpt(2), ls2(2)], 'Color', 'Yellow', 'LineWidth', 1);
plot([intpt(1), ls1(1)], [intpt(2), ls1(2)], 'Color', 'Blue', 'LineWidth', 1);

% Frontal view
plot(pt11p(1), pt11p(2), 'x', 'Color', 'magenta', 'LineWidth', 3);
plot(ls1p(1), ls1p(2), '*', 'Color', 'Cyan', 'LineWidth', 1);
plot(ls2p(1), ls2p(2), '*', 'Color', 'Cyan', 'LineWidth', 1);
plot(intptp(1), intptp(2), '*', 'Color', 'Cyan', 'LineWidth', 1);

plot([pt11p(1), ls1p(1)], [pt11p(2), ls1p(2)], 'Color', 'Black', 'LineWidth', 1);
plot([pt11p(1), ls2p(1)], [pt11p(2), ls2p(2)], 'Color', 'Black', 'LineWidth', 1);
plot([intptp(1), ls2p(1)], [intptp(2), ls2p(2)], 'Color', 'Yellow', 'LineWidth', 1);
plot([intptp(1), ls1p(1)], [intptp(2), ls1p(2)], 'Color', 'Blue', 'LineWidth', 1);
hold off;

%% Original-prespective pixel mapping
% Find the size of img
sz = size(im);
[rows,cols]= meshgrid(1:sz(1), 1:sz(2));
A = [reshape(cols,1,[]);
     reshape(rows,1,[]);
     ones(1,length(rows(:)))]; 
 
AA = H * A;
AA = AA ./ [AA(3,:); AA(3,:); AA(3,:)];
AA = int32(AA); % Truncate from float to int

szNew = sz;
ptYp = AA(2,:) - min(AA(2,:)) + 1;
ptXp = AA(1,:) - min(AA(1,:)) + 1;
ptXYp = [ptXp; ptYp; ones(1,size(ptXp,2))];
szNew(1) = max(ptYp);
szNew(2) = max(ptXp);
% ind(pixel_location) = y + (x - 1) * y_stride
ind = ptYp + ((ptXp - 1) * szNew(1));
indOld = A(2,:) + ((A(1,:) - 1) * sz(1));

%% Pixel index to coordinate conversion
% pt11p_ind = int32(ls1(1) + ((ls1(2) - 1) * sz(2)));
% coordin = ptXYp(1:2,pt11p_ind);% A(1:2, pt11p_ind);
ls1a_ind = floor(ls1(1)) + ((floor(ls1(2)) - 1) * sz(2));
ls1b_ind = floor(ls1(3)) + ((floor(ls1(4)) - 1) * sz(2));
ls1_proj = [ptXYp(1:2,ls1a_ind); ptXYp(1:2,ls1b_ind)];

ls2a_ind = floor(ls2(1)) + ((floor(ls2(2)) - 1) * sz(2));
ls2b_ind = floor(ls2(3)) + ((floor(ls2(4)) - 1) * sz(2));
ls2_proj = [ptXYp(1:2,ls2a_ind); ptXYp(1:2,ls2b_ind)];

pt11_C_ind = floor(pt11_C(1) + ((pt11_C(2) - 1) * sz(2)));
pt11_C_proj = ptXYp(1:2, pt11_C_ind);
figure, imshow(im_warp);
figure, imshow(im_warp2);
hold on;
plot(ls1_proj([1,3],:), ls1_proj([2,4],:), 'x', 'Color', 'cyan', 'LineWidth', 3);
plot(ls2_proj([1,3],:), ls2_proj([2,4],:), 'x', 'Color', 'cyan', 'LineWidth', 3);
plot(pt11_C_proj(1), pt11_C_proj(2), 'x', 'Color', 'magenta', 'LineWidth', 3);

plot([ls1_proj(1), ls2_proj(3)], [ls1_proj(2), ls2_proj(4)], 'Color', 'Blue', 'LineWidth', 3);
plot([ls1_proj(3), ls2_proj(1)], [ls1_proj(4), ls2_proj(2)], 'Color', 'Yellow', 'LineWidth', 3);
plot([ls1_proj(1), pt11_C_proj(1)], [ls1_proj(2), pt11_C_proj(2)], 'Color', 'Red', 'LineWidth', 3);
plot([ls2_proj(1), pt11_C_proj(1)], [ls2_proj(2), pt11_C_proj(2)], 'Color', 'Red', 'LineWidth', 3);
% plot([intpt(1), ls1(1)], [intpt(2), ls1(2)], 'Color', 'Blue', 'LineWidth', 1);
hold off;