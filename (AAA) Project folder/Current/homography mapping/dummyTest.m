%% Program Initialisation
addpath(genpath('.'));
%% Waiting for user input
figure;
imshow(im);
hold on;
[lsX, lsY] = getpts;    % Get points from user select
hold off;
close;
%% Pre-defined parameters from previous program
% Image center
center = [size(im,2)/2; size(im,1)/2];

%% Construct homography matrix
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
X = [0.144172003541432,0.161887680849420,-0.099848173348471,0.138800848766926;
    -0.776721177515494,0.719557697158842,1.123899011861867,-0.804358007244892];
ax = X(1,1);ay=X(2,1);
R = makehgtform('xrotate',ax,'yrotate',ay); R=R(1:3,1:3);
H = K*R*inv(K);
tform = projective2d(H');
%% Line boundary defined by users in the format of [x1,y1;x2,y2]
% 1st Line Segment
ls1 = [lsX(1); lsY(1); lsX(2); lsY(2)];     
ls1_C = ls1 - repmat(center, 2, size(ls1, 2));  % Center subtracted

% 2nd line segment
ls2 = [lsX(3); lsY(3); lsX(2); lsY(2)];
ls2_C = ls2 - repmat(center, 2, size(ls2, 2));  % Center subtracted

% Construct line equation from the line segment defined 
lv1 = twopts2L(ls1_C);
lv2 = twopts2L(ls2_C);

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

% Plus center
intpt = intpt + center;
figure, imshow(im);
hp = impixelinfo;
set(hp,'Position',[5 1 300 20]);
%% Show some manually choosen points ans LS
hold on;
plot(ls1(1), ls1(2), '*', 'Color', 'Cyan', 'LineWidth', 3);
plot(ls2(1), ls2(2), '*', 'Color', 'Cyan', 'LineWidth', 3);
plot(intpt(1), intpt(2), '*', 'Color', 'Cyan', 'LineWidth', 3);

plot([intpt(1), ls2(1)], [intpt(2), ls2(2)], 'Color', 'Yellow', 'LineWidth', 3);
plot([intpt(1), ls1(1)], [intpt(2), ls1(2)], 'Color', 'Blue', 'LineWidth', 3);
hold off;

%% Warping
im_warp = my_imwarp(im, H);

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

ptYp = AA(2,:) - min(AA(2,:)) + 1;
ptXp = AA(1,:) - min(AA(1,:)) + 1;
ptXYp = [ptXp; ptYp];

%% Pixel coordinate to index conversion
% ind(pixel_location) = y + (x - 1) * y_stride
ls1a_ind = floor(ls1(1)) + ((floor(ls1(2)) - 1) * sz(2));
ls1b_ind = floor(ls1(3)) + ((floor(ls1(4)) - 1) * sz(2));
ls1_proj = [ptXYp(:,ls1a_ind); ptXYp(:,ls1b_ind)];

ls2a_ind = floor(ls2(1)) + ((floor(ls2(2)) - 1) * sz(2));
ls2b_ind = floor(ls2(3)) + ((floor(ls2(4)) - 1) * sz(2));
ls2_proj = [ptXYp(:,ls2a_ind); ptXYp(:,ls2b_ind)];

figure, imshow(im_warp);
hold on;
plot(ls1_proj([1,3],:), ls1_proj([2,4],:), 'x', 'Color', 'cyan', 'LineWidth', 3);
plot(ls2_proj([1,3],:), ls2_proj([2,4],:), 'x', 'Color', 'cyan', 'LineWidth', 3);

plot([ls1_proj(1), ls2_proj(3)], [ls1_proj(2), ls2_proj(4)], 'Color', 'Blue', 'LineWidth', 3);
plot([ls1_proj(3), ls2_proj(1)], [ls1_proj(4), ls2_proj(2)], 'Color', 'Yellow', 'LineWidth', 3);
hold off;
















% 
% 
% %% Show the plot of line segment mapping relation
% figure, hold on,
% % Original view
% plot(ls1(1), ls1(2), '*', 'Color', 'Green', 'LineWidth', 1);
% plot(ls2(1), ls2(2), '*', 'Color', 'Green', 'LineWidth', 1);
% plot(intpt(1), intpt(2), '*', 'Color', 'Green', 'LineWidth', 1);
% 
% plot([intpt(1), ls2(1)], [intpt(2), ls2(2)], 'Color', 'Yellow', 'LineWidth', 1);
% plot([intpt(1), ls1(1)], [intpt(2), ls1(2)], 'Color', 'Blue', 'LineWidth', 1);
% 
% % Frontal view
% plot(ls1p(1), ls1p(2), '*', 'Color', 'Cyan', 'LineWidth', 1);
% plot(ls2p(1), ls2p(2), '*', 'Color', 'Cyan', 'LineWidth', 1);
% plot(intptp(1), intptp(2), '*', 'Color', 'Cyan', 'LineWidth', 1);
% 
% plot([intptp(1), ls2p(1)], [intptp(2), ls2p(2)], 'Color', 'Yellow', 'LineWidth', 1);
% plot([intptp(1), ls1p(1)], [intptp(2), ls1p(2)], 'Color', 'Blue', 'LineWidth', 1);
% hold off;
