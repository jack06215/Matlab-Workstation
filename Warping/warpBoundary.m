% Cleaning up the screen and previous variables
clear; 
close all;
clc;

% Read in an image
img = imread('../(Sample Images)\fig1.jpg');

% This is the homography matrix
m =[1, -0.4, 0
    0.4 1, 0
    0, 0, 1];

% Find the size of img
sz = size(img);

% Funtion-wise explanation:
%   Construct the column vector (matrix) of input image
% ----------------------------------------------------------------------
% Code-wise explanation:
%   - Create rectangle with the dimension of sz(2) by sz(1)
%   - Assign vector X with the values from 1 to sz(2) at each ROW (X-dir)
%     while assign vector Y  with the value from 1 to sz(1) at each COL (Y-dir)
%   - Create vector A with dimension of (1 * sizeof(X)) by (1 * sizeof(Y)) by 1
%     filled with ones.
tic;
[X,Y]= meshgrid(1:sz(2), 1:sz(1));
A = [reshape(Y,1,[]);
     reshape(X,1,[]);
     ones(1,length(Y(:)))];
 

% Calcuate the geometry transformation using given homography matrix
% [x' y' 1] = T(h) * A
% T (h) is 3x3 homography matrix
AA = m * A;
AA = AA ./ [AA(3,:); AA(3,:); AA(3,:)];
AA = int32(AA); % Truncate from float to int

% Update the new dimension of warped image
szNew = sz;
a1 = AA(1,:) - min(AA(1,:)) +1;
a2 = AA(2,:) - min(AA(2,:)) +1;
A_warpped = [a1;a2];
szNew(1) = max(a1);
szNew(2) = max(a2);

% Map the pixel location 
% w + h * stride
ind = a1 + (a2 - 1) * szNew(1);
indOld = A(1,:) + (A(2,:) - 1) * sz(1);

% Find the pixel index of corner location in the image,
% [1:size(img, 1)] + [1:(size(img, 2) - 1)] * size(img, 1)
% 
% tl = [1,1] 
% tr = [img.width, 1] 
% rb = [img.width, img.height]
% rl = [1, img.height]
tl_index = 1 + (1 - 1) * sz(1);           
tr_index = size(img, 1) + (1 - 1) * sz(1);
br_index = size(img, 1) + (size(img, 2) - 1) * sz(1);
bl_index = 1 + (size(img, 2) - 1) * sz(1);

tl = A_warpped(:,tl_index);
tr = A_warpped(:,tr_index);
br = A_warpped(:,br_index);
bl = A_warpped(:,bl_index);

% Create an new image to be mapped, firstly we initialise it with zeors
imgNew = uint8(zeros(szNew(1), szNew(2),3));

% Map RGB color space from input_image
imgNew(ind) = img(indOld);
imgNew(ind + szNew(1) * szNew(2)) = img(indOld + sz(1) * sz(2));
imgNew(ind + szNew(1) * szNew(2) * 2) = img(indOld + sz(1) * sz(2) * 2);
toc;

% Display the reuslt
figure('position',[200,500,500,300]);
imshow(img), hold on;
% plot(100,200,'cyan+','MarkerSize',20, 'LineWidth', 3);
figure('position',[800,500,500,300]);
hold off;
imshow(imgNew), hold on
plot(tl(2),tl(1),'cyan+','MarkerSize',20, 'LineWidth', 3);
plot(tr(2),tr(1),'cyan+','MarkerSize',20, 'LineWidth', 3);
plot(br(2),br(1),'cyan+','MarkerSize',20, 'LineWidth', 3);
plot(bl(2),bl(1),'cyan+','MarkerSize',20, 'LineWidth', 3);
hold off;