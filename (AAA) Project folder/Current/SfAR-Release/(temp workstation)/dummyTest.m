im = imread('data\DSC_0760.JPG');
figure, hold on;
imshow(im);

% To do - manipulate z-axis
alpha = 0.45;
R = makehgtform('zrotate',alpha); R = R(1:3,1:3);


H = inv(K * R' * inv(K));
tform = projective2d(H');
im_warp = imwarp(im, tform);
figure, imshow(im_warp);
