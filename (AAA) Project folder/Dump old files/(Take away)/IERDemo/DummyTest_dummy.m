%% Stage 1 - LSD for obtaining vertical line segments

% Setup
close all;
img = imread('The-Equitable-Building-With-The-New-Trust-Company-Of-Georgia-Building-In-The-Background-Between-1968-And-1971-Georgia-State-University-Library.jpg');

% LSD Detection
img_bw = rgb2gray(img);
lines = DummyTest_getLines(img_bw, 40);

% Obtain vertical lines
index = 1;
for j = 1:size(lines,1)
    angle_orientation = rad2deg(lines(j,5) + pi/2);
    if (angle_orientation >= 75 && angle_orientation <= 115)
        verticalLines(index,1:3) = horzcat(lines(j,1:2), 1);
        verticalLines(index,4:6) = horzcat(lines(j,3:4), 1);
        index = index + 1;
    end
end
%% Plot the result
figure, imshow(img),hold on;
for j = 1:size(verticalLines,1)
    plot(verticalLines(j,1), verticalLines(j,4), 'o', 'Color', 'Red', 'LineWidth', 3);
    plot(verticalLines(j,2), verticalLines(j,5), 'o', 'Color', 'Cyan', 'LineWidth', 3);
    plot(verticalLines(j,1:2),verticalLines(j,4:5),'Color','Blue', 'LineWidth', 3);
end

%% Stage 2 - Image Rectification using Levenberg–Marquardt

% Rotation parameter for each axis of the camera
theta = 1;  % for Y-axis (pitch)
phi = 1;    % for X-axis (roll)

% Default intrinsic parameter
fx = 1; % size(img_bw, 2) / 2;
fy = 1; % size(img_bw, 1) / 2;
intrinsic = [   fx 0 0; 
                0 fy 0; 
                0 0  1];
% Rotation matrix for each axis
rotation_theta = [   cos(theta)  0  -sin(theta);
                        0        1        0   ;
                     sin(theta)  0   cos(theta)];
rotation_phi = [    1    0         0; 
                    0 cos(phi)  sin(phi); 
                    0 -sin(phi) cos(phi)];
                
rotation = rotation_theta .* rotation_phi;

% Projective
projection = intrinsic .* rotation;


