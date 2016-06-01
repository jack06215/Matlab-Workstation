addpath(genpath('.'));
close all;
% Parameters
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
% img = imread('data/Garfield_Building_Detroit.jpg');
im_obj = imread('data/lucky_star_hiragana_wall_chart_by_muddy_mudkip.jpg');
im_obj_rect = [1,size(im_obj,2),size(im_obj,2),1;
                1,1,size(im_obj,1),size(im_obj,1)];
center = [size(img,2)/2; size(img,1)/2];
C_center = [1,0, -center(1);
            0,1, -center(2);
            0,0,1];
leftmosst_wall = [1;1;1;size(img,1)];
rightmost_wall = [size(img,2);1;size(img,2);size(img,1)];
        
        
%list_A = [174,167,54,84];
list_A = [104,113,207,41];
quad_a = ls(:,list_A(:));

% Sort out line segments
L = twopts2L(quad_a);
ref = repmat(-eps,(size(L(1:2,:))));
diff = abs(L(1:2,:)) - ref;
[~,ind] = min(diff,[],1);
[~,ind] = sort(ind);
L_sort = L(:,ind);

combinations = [1,3;...
                1,4;...
                2,3;...
                2,4;];

quad = zeros(2,4);            
for i=1:size(combinations,1)
    lv1 = L_sort(:,combinations(i,1));
    lv2 = L_sort(:,combinations(i,2));
    tmp = az_hcross(lv1,lv2);
    quad(:,i) = tmp(1:2);
end
leftPlane = [0,imgPlane_boundary(1),0,imgPlane_boundary(1);...
              0,0,imgPlane_boundary(1),imgPlane_boundary(1);...
              1,1,1,1];

rightPlane = [0,size(img,2)-imgPlane_boundary(1),0,size(img,2)-imgPlane_boundary(1);...
              0,0,size(img,2)-imgPlane_boundary(1),size(img,2)-imgPlane_boundary(1);...
              1,1,1,1];
figure
imshow(img),hold on;


% quad = [quad(:,2),quad(:,1),quad(:,4),quad(:,3)];
for i=1:size(list_A,2)
   plot(quad_a([1,3],i), quad_a([2,4],i), 'Color', 'red', 'LineWidth', 2);
   plot(quad(1,i),quad(2,i),'x','Color','blue','LineWidth',2);
end
quad = [quad;1,1,1,1];
% [x,y] = getpts;
% quad = [x(1),x(2),x(3),x(4); y(1),y(2),y(3),y(4); 1,1,1,1];
% plot(quad(1,:),quad(2,:),'x','color','blue','linewidth',3);
hold off;
% figure(1);
% 
% line = imrect;
% my_roi = wait(line);
% h = my_roi(4);
% hold on;
% rect = [my_roi(1),my_roi(1)+my_roi(3),my_roi(1)+my_roi(3),my_roi(1);
%             my_roi(2),my_roi(2),my_roi(2)+my_roi(4),my_roi(2)+my_roi(4)];
% plot(rect(1,:),rect(2,:),'x','color','red','linewidth',3);
% 
% project_rect = [0,h,0,h;0,0,h,h;1,1,1,1];
Rect_t = [0,size(img,2),0,size(img,2);0,0,size(img,2),size(img,2);1,1,1,1];
% Rect_t = [Rect_t(:,1),Rect_t(:,3),Rect_t(:,4),Rect_t(:,2)];
% H = homography2d(quad,rightPlane);
% H = homography2d(quad,leftPlane);
H = homography2d(quad,Rect_t);
H_K = K\H;
s = norm(H_K(:,2)) / norm(H_K(:,1));


A_s = [1,1/s,1];
AA_s = diag(A_s);
H1 = H * AA_s;
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
im_warp = imwarp(img, T');
T_t = T.T;
% figure,imshow(im_new);

sz = size(img);
% Original pixel index lookup table
[rows,cols]= meshgrid(1:sz(1), 1:sz(2));
A = [reshape(cols,1,[]);
     reshape(rows,1,[]);
     ones(1,length(rows(:)))]; 
% Perform warping 
AA = T_t' * A;
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
ptsp=inv(T_t)'*pts; 
ptsp=ptsp(1:2,:)./[ptsp(3,:);ptsp(3,:)]; % Normalise w dimension
%% Extract the back-project points coordinate
ls1p_back=[ptsp(:,1);ptsp(:,2)];ls1p_back = floor(ls1p_back);
ls2p_back=[ptsp(:,3);ptsp(:,4)];ls2p_back = floor(ls2p_back);

im_rect = [ls1p_back(1),ls1p_back(3),ls2p_back(1),ls2p_back(3);
            ls1p_back(2),ls1p_back(4),ls2p_back(2),ls2p_back(4)];
T_1 = fitgeotrans(im_obj_rect',im_rect','projective');
im_obj_warp = imwarp(im_obj, T_1);
T_H = T_1.T;

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
mask = poly2mask(x_vertices,y_vertices,size(img,1),size(img,2));
pixel_index = find(mask==1);
%% Change RGB within the 4 points bounding region defined
img_enplace = img;
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
imshow(img);
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