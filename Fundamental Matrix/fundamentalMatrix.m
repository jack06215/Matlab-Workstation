%% 0. Program parameter
num_of_points = 20;
SVD_or_LS = true; % True for SVD, false for Least-Square
rank = 2;
image_width = 256;
image_height = 256;
%% 1. Define camera 1 and 2 parameters (Insrinsic and Extrinsic)
% Camera 1
C1_Intrinsic = [ 100, 0  ,  128, 0;
                   0 , 120, 128, 0;
                   0 ,   0 ,   1, 0];
RC1 = eye(3);
C1_Extrinsic = [RC1(1, :), 0;
                RC1(2, :), 0;
                RC1(3, :), 0;
                0, 0, 0, 1];
% Camera 2
C2_Intrinsic = [90, 0, 128, 0;
                  0, 110, 128, 0;
                  0, 0, 1, 0];
Rx = 0.1;
Ry = pi / 4;
Rz = 0.2;
C2_Rx = [1,   0    ,   0;
         0, cos(Rx), -sin(Rx);
         0, sin(Rx), cos(Rx)];
     
C2_Ry = [cos(Ry) ,   0, sin(Ry);
            0    ,   1,    0;
         -sin(Ry),   0, cos(Ry)];
     
C2_Rz = [cos(Rz), -sin(Rz), 0;
         sin(Rz), cos(Rz) , 0;
         0      , 0       , 1];

RC2 = C2_Rx * C2_Ry * C2_Rz;

c1Kc2 = [RC2(1, :), -1000;
         RC2(2, :), 190;
         RC2(3, :), 230;
         0, 0, 0, 1];
C2_Extrinsic = inv(c1Kc2);
%% 2. Obtain Fundamantal Matrix analytically as the product of matrices defined in step 1
tx = [0, -230, 190;
      230, 0, 1000;
      -190, -1000, 0];
%C1_F = inv(C2_Intrinsic(:,1:3).') * RC2.' * tx * inv(C1_Intrinsic(:,1:3));
% inv(A)* b  ==> A\b
% A * inv(b) ==> A/b
C1_F = (transpose(C2_Intrinsic(:,1:3)) \ transpose(RC2)) * (tx /(C1_Intrinsic(:,1:3)));
C2_F = (transpose(C1_Intrinsic(:,1:3)) \ tx) * (RC2 / transpose(C2_Intrinsic(:,1:3)));
C1_F_ANALYTIC = C1_F/ C1_F(3,3);
C2_F_ANALYTIC = C2_F/ C2_F(3,3);
%% 3. Define a set of object points(3D homogenous coordinate) w.r.t. the world (i.e. Camera 1) coordinate system
V(:,1) = [400;-400;2000;1];
V(:,2) = [300;-400;3000;1];
V(:,3) = [500;-400;4000;1];
V(:,4) = [700;-400;2000;1];

V(:,5) = [900;-400;3000;1];
V(:,6) = [100;-50;4000;1];
V(:,7) = [300;-50;2000;1];
V(:,8) = [500;-50;3000;1];

V(:,9) = [700;-50;4000;1];
V(:,10) = [900;-50;2000;1];
V(:,11) = [100;50;3000;1];
V(:,12) = [300;50;4000;1];

V(:,13) = [500;50;2000;1];
V(:,14) = [700;50;3000;1];
V(:,15) = [900;50;4000;1];
V(:,16) = [100;400;2000;1];

V(:,17) = [300;400;3000;1];
V(:,18) = [500;400;4000;1];
V(:,19) = [700;400;2000;1];
V(:,20) = [900;400;3000;1];
%% 4. Compute the couples of image points in both image planes
% Compute the projection on the image plane of the 1st camera
C1_iTw = C1_Intrinsic * C1_Extrinsic; % Transformation Mat from world to image plane
scaled_pixels = C1_iTw * V;
scale = scaled_pixels(3,:);
m = scaled_pixels ./ [scale;scale;scale];
% Compute the projection on the image plane of the 2nd camera
C2_iTw = C2_Intrinsic * C2_Extrinsic; % Transformation Mat from world to image plane
scaled_pixels = C2_iTw * V;
scale = scaled_pixels(3,:);
m_prime = scaled_pixels ./ [scale;scale;scale];

%% 5. Open two windows for both image planes, showing 2D points obtained in step 4
scrsz = get(0, 'ScreenSize');
Figure1 = figure('Position', [scrsz(1), scrsz(2), scrsz(3), scrsz(4)]);
% -------------------------------------------------
% 1st Camera
subplot(1, 2, 1);
hold on;
axis ij;
axis equal;
% Plot image plane (Yellow Rectangle)
plot([1, image_width], [1, 1], 'Color', 'y', 'LineWidth', 2);
plot([1, 1], [1 image_height], 'Color', 'y', 'LineWidth', 2);
plot([image_width, image_width], [1, image_height], 'Color', 'y', 'LineWidth', 2);
plot([image_width, 1], [image_height, image_height],  'Color', 'y', 'LineWidth', 2);
% Draw pixels corresponding to 3D points
Figure_C1_Points = plot(m(1,:), m(2,:), '*');
xlabel('pixels');
ylabel('pixels');
title('2D points on the image plane of the 1st camera');
% -------------------------------------------------
% 2nd Camera
subplot(1, 2, 2);
hold on;
axis ij;
axis equal;
% Plot image plane (Yellow Rectangle)
plot([1, image_width], [1, 1], 'Color', 'y', 'LineWidth', 2);
plot([1, 1], [1 image_height], 'Color', 'y', 'LineWidth', 2);
plot([image_width, image_width], [1, image_height], 'Color', 'y', 'LineWidth', 2);
plot([image_width, 1], [image_height, image_height],  'Color', 'y', 'LineWidth', 2);
% Draw pixels corresponding to 3D points
Figure_C2_Points = plot(m_prime(1,:), m_prime(2,:), '*');
xlabel('pixels');
ylabel('pixels');
title('2D points on the image plane of the 2nd camera');
%% 6. Compute the Fundamental matrix
F1 = computeFundMat(m, m_prime, SVD_or_LS, num_of_points);
F2 = computeFundMat(m_prime, m, SVD_or_LS, num_of_points);
%% 7. Compare the difference with analytic
diff1 = F1 - C1_F_ANALYTIC; diff1;
diff2 = F2 - C2_F_ANALYTIC; diff2;
%% 8. Draw all the epipolar geometry using the Fundamental matrix
% Draw epipolar lines of the 1st camera
l2 = F1 * m;
l1 = F2 * m_prime;

x1 = -600:600;
x2 = -600:600;

m1 = -l1(1,:)./l1(2,:);
d1 = -l1(3,:)./l1(2,:);
m2 = -l2(1,:)./l2(2,:);
d2 = -l2(3,:)./l2(2,:);
Figure2 = copy(Figure1);
for i = 1:1
    y1(i,:) = m1(i) * x1 + d1(i);
    y2(i,:) = m2(i) * x2 + d2(i);
    subplot(1,2,1); hold on;
    Figure_C1_EpipolarLines = plot(x1,y1(i,:), '-', 'Color', 'b');
    xlim([-600 600]);
    ylim([-600 600]);
    axis square;
    title('2D Points and Epipolar Line & Epipole of Camera 1');
    
    subplot(1,2,2); hold on;
    Figure_C2_EpipolarLines = plot(x2,y2(i,:), '-', 'Color', 'b');
    xlim([-600 600]);
    ylim([-600 600]);
    axis square;
    title('2D Points and Epipolar Line & Epipole of Camera 2');
    
end
%% 9. Draw the epipole for each camera
C2_wrt_C1 = [c1Kc2(1:3,4);1];
C1_Epipole = C1_Intrinsic * C1_Extrinsic * C2_wrt_C1;
C1_Epipole = C1_Epipole / C1_Epipole(3);

C1_wrt_C1 = [0;0;0;1];
C2_Epipole = C2_Intrinsic * C2_Extrinsic * C1_wrt_C1;
C2_Epipole = C2_Epipole / C2_Epipole(3);
subplot(1,2,1); hold on;
Figure_C1_Epipole = plot(C1_Epipole(1), C1_Epipole(2), 'o', 'Color', 'Red');
legend([Figure_C1_EpipolarLines, Figure_C1_Epipole], 'Epipolar Lines', 'Epipole');
subplot(1,2,2); hold on;
Figure_C2_Epipole = plot(C2_Epipole(1), C2_Epipole(2), 'o', 'Color', 'Red');
legend([Figure_C2_EpipolarLines, Figure_C2_Epipole], 'Epipolar Lines', 'Epipole');