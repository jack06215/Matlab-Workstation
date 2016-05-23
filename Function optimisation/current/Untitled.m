addpath(genpath('.'));
ccc;
% Parameters
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
img = imread('data/Garfield_Building_Detroit.jpg');
center = [size(img,2)/2; size(img,1)/2];
C_center = [1,0, -center(1);
            0,1, -center(2);
            0,0,1];

figure
imshow(img),hold on;
[x,y] = getpts;
quad = [x(1),x(2),x(3),x(4); y(1),y(2),y(3),y(4); 1,1,1,1];
plot(quad(1,:),quad(2,:),'x','color','blue','linewidth',3);
hold off;
figure(1);

line = imrect;
my_roi = wait(line);
h = my_roi(4);
hold on;
rect = [my_roi(1),my_roi(1)+my_roi(3),my_roi(1)+my_roi(3),my_roi(1);
            my_roi(2),my_roi(2),my_roi(2)+my_roi(4),my_roi(2)+my_roi(4)];
plot(rect(1,:),rect(2,:),'x','color','red','linewidth',3);

project_rect = [0,h,0,h;0,0,h,h;1,1,1,1];

H = homography2d(quad,project_rect);

H_K = K\H;
s = norm(H_K(:,2)) / norm(H_K(:,1));

A = [1,1/s,1];
AA = diag(A);
H1 = H * AA;
%% Calclating Resultant Translation and Scale
Rect = [0,0,1; size(img,2),0,1; size(img,2),size(img,1),1; 0,size(img,1),1]';
Rect_out = homoTrans(H1, Rect);
%% Fix scaling, based on length.
scale_fac = abs((max(Rect_out(1,2), Rect_out(1,3))- min(Rect_out(1,1), Rect_out(1,4)))/size(img,2));
Rect_out = Rect_out./repmat(scale_fac,3,4);
%% Shift the Rect_out back to "pixel coordinate" w.r.t. Rect
Rect_out(1,2) = Rect_out(1,2) - Rect_out(1,1);
Rect_out(2,2) = Rect_out(2,2) - Rect_out(2,1);
Rect_out(1,3) = Rect_out(1,3) - Rect_out(1,1);
Rect_out(2,3) = Rect_out(2,3) - Rect_out(2,1);
Rect_out(1,4) = Rect_out(1,4) - Rect_out(1,1);
Rect_out(2,4) = Rect_out(2,4) - Rect_out(2,1);
Rect_out(1,1) = Rect_out(1,1) - Rect_out(1,1);
Rect_out(2,1) = Rect_out(2,1) - Rect_out(2,1);
% Conversion: dropping off the 'w coordinate', and transpose
Rect = Rect(1:2,:)'; 
Rect_out = Rect_out(1:2,:)';
%% Fit geometric transform between Rect and Rect_out
T = fitgeotrans(Rect,Rect_out,'projective');
im_new = imwarp(img, T');
figure,imshow(im_new);






% quad = project_rect';

% tform = fitgeotrans(quad,project_rect','projective');
% P = tform.T';
% P = K\P;
% s = norm(P(:,1)) / norm(P(:,2));
% R1 = P(:,1)./s;
% R2 = P(:,2);
% R3 = cross(R1,R2);
% P = [R1,R2,R3];




% Warping
% C_center = [1,0, -center(1);
%             0,1, -center(2);
%             0,0,1];
% H1= K*(P/K)*C_center;
% % T = projective2d(H1);
% 
% %% Calclating Resultant Translation and Scale
% Rect = [0,0,1; size(img,2),0,1; size(img,2),size(img,1),1; 0,size(img,1),1]';
% Rect_out = homoTrans(H1, Rect);
% %% Fix scaling, based on length.
% scale_fac = abs((max(Rect_out(1,2), Rect_out(1,3))- min(Rect_out(1,1), Rect_out(1,4)))/size(img,2));
% % Rect_out = Rect_out./repmat(scale_fac,3,4);
% %% Shift the Rect_out back to "pixel coordinate" w.r.t. Rect
% Rect_out(1,2) = Rect_out(1,2) - Rect_out(1,1);
% Rect_out(2,2) = Rect_out(2,2) - Rect_out(2,1);
% 
% Rect_out(1,3) = Rect_out(1,3) - Rect_out(1,1);
% Rect_out(2,3) = Rect_out(2,3) - Rect_out(2,1);
% Rect_out(1,4) = Rect_out(1,4) - Rect_out(1,1);
% Rect_out(2,4) = Rect_out(2,4) - Rect_out(2,1);
% Rect_out(1,1) = Rect_out(1,1) - Rect_out(1,1);
% Rect_out(2,1) = Rect_out(2,1) - Rect_out(2,1);
% % Conversion: dropping off the 'w coordinate', and transpose
% Rect = Rect(1:2,:)'; 
% Rect_out = Rect_out(1:2,:)';
% %% Fit geometric transform between Rect and Rect_out
% T = fitgeotrans(Rect,Rect_out,'projective');
% im_new = imwarp(img, T');