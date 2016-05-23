%% Define principle center
%       1   0   CenterX
% T =   0   1   CenterY
%       0   0     1
T_center = [1,0,center(1); 0,1,center(2);0,0,1];

%% Construct rotation matrix
ax=X3(4);ay=X3(5);az=X3(6);
R1=makehgtform('xrotate',ax,'yrotate',ay, 'zrotate',az);
R1=R1(1:3,1:3);
%% Construct homography induced by plane
H2 = K * R1/K;
H2 = (T_center * H2/T_center);
%% Make tfrom and wapr image
tform = projective2d(H2');
cut_img = imwarp(im,tform);
figure, imshow(cut_img);