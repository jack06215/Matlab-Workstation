%% Program Initialisation
addpath(genpath('.'));
close all;
%% Waiting for user input
im_obj = imread('LLTV2_illustration_logo.jpg');
im_obj_rect = [1,size(im_obj,2),size(im_obj,2),1;
                1,1,size(im_obj,1),size(im_obj,1)];
%% Pre-defined parameters from previous program
% Image center
center = [size(im,2)/2; size(im,1)/2];
%% Construct homography matrix
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
% K = [791,0,0;0,791,0;0,0,1];
% X = [0.150029936810503,0.143176210731948;-0.595200087397920,0.381606944802646;0.131683946642265,-0.090483451186387];
% X = [0.946461255663448,-0.548922823284659;-0.023890003326811,-5.852889297814638e-04;0.007198255854039,0.008453552961197];
H_form = computeFrontalH(X3(:,2), center, K, im);
H = H_form.T;
%% Warping
im_warp = imwarp(im, H_form);
% im_warp = my_imwarp(im, H');
%% Look-up table for original-prespective pixel mapping(Scene)
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
%% Get 4 points from user
while (1)
    figure, imshow(im_warp);
    hold on;
    line = imrect;
    my_roi = wait(line);
    position = [my_roi(1),my_roi(1)+my_roi(3),my_roi(1)+my_roi(3),my_roi(1);
                my_roi(2),my_roi(2),my_roi(2)+my_roi(4),my_roi(2)+my_roi(4)];
    hold off;
    close;
    if (size(position,2)==4)
        break;
    end
end
ptXp = position(1,:);
ptYp = position(2,:);
lsX = floor(ptXp);lsY = floor(ptYp);
lsX = lsX + double(repmat(min(AA(1,:)) - 1,size(lsX,1),1)); 
lsY = lsY + double(repmat(min(AA(2,:)) - 1,size(lsY,1),1));
%% Apply inverse homography to the 4 points
ls1p = [lsX(1); lsY(1); lsX(2); lsY(2)];
ls2p = [lsX(3); lsY(3); lsX(4); lsY(4)];
lv1p = twopts2L(ls1p);
lv2p = twopts2L(ls2p);
pts=[[ls1p(1:2),ls1p(3:4),ls2p(1:2),ls2p(3:4)];[1,1,1,1]];
ptsp=inv(H)'*pts; 
ptsp=ptsp(1:2,:)./[ptsp(3,:);ptsp(3,:)]; % Normalise w dimension
%% Extract the back-project points coordinate
ls1p_back=[ptsp(:,1);ptsp(:,2)];ls1p_back = floor(ls1p_back);
ls2p_back=[ptsp(:,3);ptsp(:,4)];ls2p_back = floor(ls2p_back);

im_rect = [ls1p_back(1),ls1p_back(3),ls2p_back(1),ls2p_back(3);
            ls1p_back(2),ls1p_back(4),ls2p_back(2),ls2p_back(4)];
T = fitgeotrans(im_obj_rect',im_rect','projective');
im_obj_warp = imwarp(im_obj, T);
T_H = T.T;

%% Experiment
% Look-up table for image object(Augmented object)...........<<<<<<<
% Find the size of img
sz = size(im_obj);
% Original pixel index lookup table
[rows,cols]= meshgrid(1:sz(1), 1:sz(2));
B = [reshape(cols,1,[]);
     reshape(rows,1,[]);
     ones(1,length(rows(:)))]; 
% Perform warping 
BB = T_H' * B;
BB = BB ./ [BB(3,:); BB(3,:); BB(3,:)];
BB = int32(BB); % Truncate from float to int
ptYp_1 = BB(2,:) - min(BB(2,:)) +1;
ptXp_1 = BB(1,:) - min(BB(1,:)) +1;
ptXYp = [ptXp_1;ptYp_1];
% Image index mapping
% ind(n) == y + (x - 1) * y_stride
index_img = zeros(1,4);
index_img(1) = im_obj_rect(1) + (im_obj_rect(2) - 1) * sz(2);
index_img(2) = im_obj_rect(3) + (im_obj_rect(4) - 1) * sz(2);
index_img(3) = im_obj_rect(5) + (im_obj_rect(6) - 1) * sz(2);
index_img(4) = im_obj_rect(7) + (im_obj_rect(8) - 1) * sz(2);
im_warp_corner = [ptXYp(:,index_img(1)),ptXYp(:,index_img(2)),ptXYp(:,index_img(3)),ptXYp(:,index_img(4))];

%% Point coordinates to pixel indices conversion (experiment...)
%Object 
im_warp_corner = double(im_warp_corner);
x_vertices = [im_warp_corner(1),im_warp_corner(3),im_warp_corner(5),im_warp_corner(7),im_warp_corner(1)];
y_vertices = [im_warp_corner(2),im_warp_corner(4),im_warp_corner(6),im_warp_corner(8),im_warp_corner(2)];
mask = poly2mask(x_vertices,y_vertices,size(im_obj_warp,1),size(im_obj_warp,2));
object_index = find(mask==1);
x_vertices = [ls1p_back(1),ls1p_back(3),ls2p_back(1),ls2p_back(3),ls1p_back(1)];
y_vertices = [ls1p_back(2),ls1p_back(4),ls2p_back(2),ls2p_back(4),ls1p_back(2)];
mask = poly2mask(x_vertices,y_vertices,size(im,1),size(im,2));
pixel_index = find(mask==1);
%% Change RGB within the 4 points bounding region defined
img_enplace = im;
img_objectContent = im_obj_warp;
img_stride = size(img_enplace,1) * size(img_enplace,2);
img_content_stride = size(im_obj_warp,1) * size(im_obj_warp,2);
img_enplace(pixel_index) = im_obj_warp(object_index);
img_enplace(pixel_index + img_stride) = im_obj_warp(img_content_stride + object_index);
img_enplace(pixel_index + (2*img_stride)) = im_obj_warp(2*img_content_stride + object_index);

%% Show the points back-projection result
% Show the points selected by user in the prespective view
figure, subplot(2,1,1);
imshow(im_warp);
hold on;
title('rectangle selected by the user in frontal-parallel view');
plot(ptXp(1), ptYp(1), 'x', 'Color', 'red', 'LineWidth', 3);
plot(ptXp(2), ptYp(2), 'x', 'Color', 'cyan', 'LineWidth', 3);
plot(ptXp(3), ptYp(3), 'x', 'Color', 'yellow', 'LineWidth', 3);
plot(ptXp(4), ptYp(4), 'x', 'Color', 'magenta', 'LineWidth', 3);
hold off;
% Back-project points to its original view
subplot(2,1,2);
imshow(im);
hold on;
title('rectangle back-project to original view');
plot(ls1p_back(1), ls1p_back(2), 'x', 'Color', 'red', 'LineWidth', 3);
plot(ls1p_back(3), ls1p_back(4), 'x', 'Color', 'cyan', 'LineWidth', 3);
plot(ls2p_back(1), ls2p_back(2), 'x', 'Color', 'yellow', 'LineWidth', 3);
plot(ls2p_back(3), ls2p_back(4), 'x', 'Color', 'magenta', 'LineWidth', 3);
hold off;
% enplace the image object onto the bounding area in original view
figure, imshow(img_enplace);
title('Augmented result in the original view');