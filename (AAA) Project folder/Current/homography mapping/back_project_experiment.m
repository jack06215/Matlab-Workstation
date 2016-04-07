%% Program Initialisation
addpath(genpath('.'));
% ccc;
%% Waiting for user input
im = imread('DSC_0760.JPG');
% figure;
% imshow(im);
% hold on;
% [lsX, lsY] = getpts;    % Get points from user select
% hold off;
% close;
%% Pre-defined parameters from previous program
% Image center
center = [size(im,2)/2; size(im,1)/2];

%% Construct homography matrix
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
X = [0.144290146310480,0.161245008361210,-0.502297992743877;-0.780126182696621,0.722906252917495,1.068252984437994;0.127068370467084,-0.144993347333665,0.094242399794410];
% ax = X(1);ay=X(2);az=X(3);
% R = makehgtform('xrotate',ax,'yrotate',ay, 'zrotate',az); R=R(1:3,1:3);
% H = K*R*inv(K);
H_form = computeFrontalH(X(:,1), center, K, im);
H = H_form.T;
% %% Warping
% % im_warp = imwarp(im, H_form);
% im_warp = my_imwarp(im, H');
% 
% %% Line boundary defined by users in the format of [x1,y1;x2,y2]
% % 1st Line Segment
% ls1 = [lsX(1); lsY(1); lsX(2); lsY(2)];     
% ls1_C = ls1 - repmat(center, 2, size(ls1, 2));  % Center subtracted
% 
% % 2nd line segment
% ls2 = [lsX(3); lsY(3); lsX(2); lsY(2)];
% ls2_C = ls2 - repmat(center, 2, size(ls2, 2));  % Center subtracted
% 
% % Construct line equation from the line segment defined 
% lv1 = twopts2L(ls1_C);
% lv2 = twopts2L(ls2_C);
% 
% %% Construct quadraliteral based on user defined input
% % Find intersection between two lines
% intpt = az_hcross(lv1,lv2); intpt = intpt(1:2); 
% 
% % Line segments + point of interection in homogenous coordinate
% pts = [[ls1_C(1:2),ls1_C(3:4),ls2_C(1:2),ls2_C(3:4),intpt];[1,1,1,1,1]];
% 
% % Apply homography and normalise w=1
% ptsp = H*pts; ptsp=ptsp(1:2,:)./[ptsp(3,:);ptsp(3,:)];
% 
% % Line segments & point ofinterection in its frontal-view
% ls1p = [ptsp(:,1);ptsp(:,2)];
% ls2p = [ptsp(:,3);ptsp(:,4)];
% intptp = ptsp(:,5);
% 
% % Plus center
% intpt = intpt + center;

% %% Show some manually choosen points ans LS
% figure, imshow(im);
% hold on;
% plot(ls1(1), ls1(2), '*', 'Color', 'Cyan', 'LineWidth', 3);
% plot(ls2(1), ls2(2), '*', 'Color', 'Cyan', 'LineWidth', 3);
% plot(intpt(1), intpt(2), '*', 'Color', 'Cyan', 'LineWidth', 3);
% 
% plot([intpt(1), ls2(1)], [intpt(2), ls2(2)], 'Color', 'Yellow', 'LineWidth', 3);
% plot([intpt(1), ls1(1)], [intpt(2), ls1(2)], 'Color', 'Blue', 'LineWidth', 3);
% hold off;

%% Look-up table for original-prespective pixel mapping
% Find the size of img
sz = size(im);
% Original pixel index lookup table
[rows,cols]= meshgrid(1:sz(1), 1:sz(2));
A = [reshape(cols,1,[]);
     reshape(rows,1,[]);
     ones(1,length(rows(:)))]; 
% Perform warping 
AA = H' * A;
AA = AA ./ [AA(3,:); AA(3,:); AA(3,:)];
AA = int32(AA); % Truncate from float to int
% Offset the pixel location
ptYp = AA(2,:) - min(AA(2,:)) + 1;
ptXp = AA(1,:) - min(AA(1,:)) + 1;
ptXYp = [ptXp; ptYp];
ptXY = A([1,2],:);
% 
% %% Pixel coordinate to index conversion
% % ind(pixel_location) = y + (x - 1) * y_stride
% ls1a_ind = floor(ls1(1)) + ((floor(ls1(2)) - 1) * sz(2));
% ls1b_ind = floor(ls1(3)) + ((floor(ls1(4)) - 1) * sz(2));
% ls1_proj = [ptXYp(:,ls1a_ind); ptXYp(:,ls1b_ind)];
% 
% ls2a_ind = floor(ls2(1)) + ((floor(ls2(2)) - 1) * sz(2));
% ls2b_ind = floor(ls2(3)) + ((floor(ls2(4)) - 1) * sz(2));
% ls2_proj = [ptXYp(:,ls2a_ind); ptXYp(:,ls2b_ind)];
% 
figure, imshow(im_warp);
hold on;
[lsX, lsY] = getpts;    % Get points from user select
lsX = int32(lsX); lsY = int32(lsY);
hold off;
% hold on;
% plot(ls1_proj([1,3],:), ls1_proj([2,4],:), 'x', 'Color', 'cyan', 'LineWidth', 3);
% plot(ls2_proj([1,3],:), ls2_proj([2,4],:), 'x', 'Color', 'cyan', 'LineWidth', 3);
% 
% plot([ls1_proj(1), ls2_proj(3)], [ls1_proj(2), ls2_proj(4)], 'Color', 'Blue', 'LineWidth', 3);
% plot([ls1_proj(3), ls2_proj(1)], [ls1_proj(4), ls2_proj(2)], 'Color', 'Yellow', 'LineWidth', 3);
% hold off;
