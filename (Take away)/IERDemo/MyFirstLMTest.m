%% Stage 1 - LSD for obtaining vertical line segments
% Setup
close all;
img = imread('Garfield_Building_Detroit.jpg');

% LSD Detection
lines = getLines(rgb2gray(img), 50);
vp = getVP3(lines,size(img,1),size(img,2));

[~, swapIdx] = min(vp(:,2));
vp([1, swapIdx],:) = vp([swapIdx, 1],:);

if (vp(2,1) > vp(3,1))
    vp([2, 3],:) = vp([3, 2],:);
end

draw(img,vp,zeros(3),lines);

% Obtain vertical lines
index = 1;
figure, imshow(img),hold on;
xOffset = -size(img,2)/2;
yOffset = -size(img,1)/2;
vert_gradient = (vp(1,2) - 0) / (vp(1,1) - 0);
horz_gradient = (vp(3,2) - vp(2,2)) / (vp(3,1) - vp(2,1));

vertBot_locationY = size(img,1) + yOffset;
vertBot_locationX = vertBot_locationY / vert_gradient;
vertTop_locationY = 0 + yOffset;
vertTop_locationX = vertTop_locationY / vert_gradient;
%%%%%%%%%%%%%%%%%%%
horzLeft_locationX = 0 + xOffset;
horzLeft_locationY = horzLeft_locationX * horz_gradient;

horzRight_locationX = size(img,2) + xOffset;
horzRight_locationY = []

% Horitontal line
plot(horzLeft_locationX + size(img,2)/2, horzLeft_locationY + size(img,1)/2, 'o', 'LineWidth', 4);
plot([vp(2,1), vp(3,1)] + size(img,2)/2, [vp(2,2), vp(3,2)] + size(img,1)/2, '-.', 'Color', 'Black', 'LineWidth', 3);

% Vertical line
plot(vertBot_locationX + size(img,2)/2, vertBot_locationY + size(img,1)/2, 'o', 'LineWidth', 4);
plot(vertTop_locationX + size(img,2)/2, vertTop_locationY + size(img,1)/2, 'o', 'LineWidth', 4);
plot([vertBot_locationX, vp(1,1)] + size(img,2)/2, [size(img,1)/2, vp(1,2)] + size(img,1)/2, '-.', 'Color', 'Black', 'LineWidth', 3);
lines = DummyTest_getLines(rgb2gray(img), 50);
verticalLines = [];
rightLines = [];
leftLines = [];
for j = 1:size(lines,1)
    angle_orientation = rad2deg(lines(j,5) + pi/2);
    if (angle_orientation >= 75 && angle_orientation <= 115)
        plot(lines(j,1:2),lines(j,3:4),'Color','Blue', 'LineWidth', 3);
        verticalLines(end+1,:) = [lines(j,1:2),lines(j,3:4)];
    elseif (angle_orientation <= 0)
        plot(lines(j,1:2),lines(j,3:4),'Color','Red', 'LineWidth', 3);
        rightLines(end+1,:) = [lines(j,1:2),lines(j,3:4)];
    else
        plot(lines(j,1:2),lines(j,3:4),'Color','Cyan', 'LineWidth', 3);
        leftLines(end+1,:) = [lines(j,1:2),lines(j,3:4)];
    end
    % pause(0.5);
end
%% Plot the result
% figure, imshow(img),hold on;
% for j = 1:size(verticalLines,1)
%     plot(verticalLines(j,1), verticalLines(j,4), 'o', 'Color', 'Red', 'LineWidth', 3);
%     plot(verticalLines(j,2), verticalLines(j,5), 'o', 'Color', 'Cyan', 'LineWidth', 3);
%     plot(verticalLines(j,1:2),verticalLines(j,4:5),'Color','Blue', 'LineWidth', 3);
% end

% %% Stage 2 - Image Rectification using Levenberg–Marquardt
% 
% % Initial guess of rotation parameter
% theta_0 = 1;
% phi_0 = 1;
% 
% updateJ = 1;
% foc = 1;
% lambda = 0.1;
% % Estimate rotation parameter
% theta_est = theta_0;  % for Y-axis (pitch)
% phi_est = phi_0;    % for X-axis (roll)
% 
% num_params = 2; % Number of paremeters
% n_iters = 1; % number of iteration to be perform
% f_err = [];          % Error function to be minimised
% e = [];
% for iter = 1:n_iters
%     if (updateJ)
%         J = zeros(num_params, num_params);
%         % Compute the Jacobian with current
%         for i = 1:length(verticalLines)
%             % [x1 x2 1 y1 y2 1]
% %             ja_theta_top = ((foc*sin(phi_est) + foc*verticalLines(i,1)*cos(phi_est))*(sin(theta_est)*(cos(phi_est) + verticalLines(i,1)*sin(phi_est)) + verticalLines(i,4)*cos(theta_est)))/(cos(theta_est)*(cos(phi_est) + verticalLines(i,1)*sin(phi_est)) - verticalLines(i,4)*sin(theta_est))^2;
% %             jb_theta_top = -(foc * verticalLines(i,2) * cos(phi_est) + foc * sin(phi_est)) * (verticalLines(i,5) * cos(theta_est) + verticalLines(i,2) * sin(phi_est) * sin(theta_est) + cos(phi_est) * sin(theta_est));
% %             ja_bottom = (verticalLines(i,4) * sin(theta_est) - (verticalLines(i,1) * sin(phi_est) + cos(phi_est)) * cos(theta_est))^2;
% %             jb_bottom = (verticalLines(i,5) * sin(theta_est) - (verticalLines(i,2) * sin(phi_est) + cos(phi_est)) * cos(theta_est))^2;
% %             
% %             ja_phi_top = (verticalLines(i,4) * sin(theta_est) - verticalLines(i,2) * sin(phi_est) * cos(theta_est) - cos(phi_est) * cos(theta_est)) * (foc * cos(phi_est) - foc * verticalLines(i,1) * sin(phi_est)) - (cos(theta_est) * sin(theta_est) - verticalLines(i,1) * cos(theta_est) * cos(phi_est)) * (foc * verticalLines(i,1) * cos(phi_est) + foc * sin(phi_est));
% %             jb_phi_top = (verticalLines(i,5) * sin(theta_est) - verticalLines(i,1) * sin(phi_est) * cos(theta_est) - cos(phi_est) * cos(theta_est)) * (foc * cos(phi_est) - foc * verticalLines(i,2) * sin(phi_est)) - (cos(theta_est) * sin(theta_est) - verticalLines(i,2) * cos(theta_est) * cos(phi_est)) * (foc * verticalLines(i,2) * cos(phi_est) + foc * sin(phi_est));
%                
%             ja_theta = -((foc*sin(phi_est) + foc*verticalLines(i,1)*cos(phi_est))*(sin(theta_est)*(cos(phi_est) + verticalLines(i,1)*sin(phi_est)) + verticalLines(i,2)*cos(theta_est)))/(cos(theta_est)*(cos(phi_est) + verticalLines(i,1)*sin(phi_est)) - verticalLines(i,2)*sin(theta_est))^2;
%             jb_theta = -((foc*sin(phi_est) + foc*verticalLines(i,4)*cos(phi_est))*(sin(theta_est)*(cos(phi_est) + verticalLines(i,4)*sin(phi_est)) + verticalLines(i,5)*cos(theta_est)))/(cos(theta_est)*(cos(phi_est) + verticalLines(i,4)*sin(phi_est)) - verticalLines(i,5)*sin(theta_est))^2;
%             J(i,1) = (ja_theta - jb_theta);
%             
%             ja_phi = - (foc*cos(phi_est) - foc*verticalLines(i,1)*sin(phi_est))/(cos(theta_est)*(cos(phi_est) + verticalLines(i,1)*sin(phi_est)) - verticalLines(i,2)*sin(theta_est)) - (cos(theta_est)*(foc*sin(phi_est) + foc*verticalLines(i,1)*cos(phi_est))*(sin(phi_est) - verticalLines(i,1)*cos(phi_est)))/(cos(theta_est)*(cos(phi_est) + verticalLines(i,1)*sin(phi_est)) - verticalLines(i,2)*sin(theta_est))^2;
%             jb_phi = - (foc*cos(phi_est) - foc*verticalLines(i,4)*sin(phi_est))/(cos(theta_est)*(cos(phi_est) + verticalLines(i,4)*sin(phi_est)) - verticalLines(i,5)*sin(theta_est)) - (cos(theta_est)*(foc*sin(phi_est) + foc*verticalLines(i,4)*cos(phi_est))*(sin(phi_est) - verticalLines(i,4)*cos(phi_est)))/(cos(theta_est)*(cos(phi_est) + verticalLines(i,4)*sin(phi_est)) - verticalLines(i,5)*sin(theta_est))^2;
%             J(i,2) = (ja_phi - jb_phi);
%             
% %             J(i,1) = ja_theta_top / ja_bottom - jb_theta_top / jb_bottom;
% %             J(i,2) = ja_phi_top / ja_bottom - jb_phi_top / jb_bottom;
% 
%         end
%         % Evaluate the column coordinate error at the current parameter
%         for i=1:length(verticalLines)
%             ja_err_top = foc * verticalLines(i,1) * cos(phi_est) + foc * sin(phi_est);
%             ja_err_bottom = (verticalLines(i,1) * sin(phi_est) + cos(phi_est)) * cos(theta_est) - verticalLines(i,2) * sin(theta_est);
%             jb_err_top = foc * verticalLines(i,4) * cos(phi_est) + foc * sin(phi_est);
%             jb_err_bottom = (verticalLines(i,4) * sin(phi_est) + cos(phi_est)) * cos(theta_est) - verticalLines(i,5) * sin(theta_est);
%             f_err(i,1) = (ja_err_top / ja_err_bottom) - (jb_err_top / jb_err_bottom); 
%         end
%         % Compute the approximated Hessian matrix: J' * J
%         H = J' * J;
%         if (iter == 1) 
%            e = dot(f_err, f_err);% At first iteration, compute the total error
%         end
%     end
%     
%     % Apply the dampling factor to the Hessian matrix
%     H_lm = H + (lambda * eye(num_params, num_params));
%     % Compute the update parameters
%     dp = -inv(H_lm) * (J' * f_err(:));
%     theta_lm = theta_est + dp(1);
%     phi_lm = phi_est + dp(2);
%     % Evaluate the total error at the current update parameters
%     for i=1:length(verticalLines)
%         ja_err_top = foc * verticalLines(i,1) * cos(phi_lm) + foc * sin(phi_lm);
%         ja_err_bottom = (verticalLines(i,1) * sin(phi_lm) + cos(phi_lm)) * cos(theta_lm) - verticalLines(i,2) * sin(theta_lm);
%         jb_err_top = foc * verticalLines(i,4) * cos(phi_lm) + foc * sin(phi_est);
%         jb_err_bottom = (verticalLines(i,4) * sin(phi_lm) + cos(phi_lm)) * cos(theta_lm) - verticalLines(i,5) * sin(theta_lm);
%         f_err_lm(i,1) = ja_err_top / ja_err_bottom - jb_err_top / jb_err_bottom; 
%     end
%     e_lm = dot(f_err_lm, f_err_lm);
%     % If the total error of the update parameters is less than the previous
%     % one then makes the update parameters to the current parameters and
%     % decrease the value of the dampling factor. Otherwise, increase the
%     % value of the dampling factor.
%      if e_lm < e
%          lambda = lambda / 10;
%          check =  e_lm < e;
%          theta_est = theta_lm;
%          phi_est = phi_lm;
%          e = e_lm;
%          % disp(e);
%          updateJ = 1;
%          disp(check);
%      else
%           updateJ = 0;
%           lambda = lambda * 10;
%     end   
% end
% disp(theta_est)
% disp(phi_est)


% % Default intrinsic parameter
% foc = 1;
% k_int = [   foc 0 0; 
%             0 foc 0; 
%             0  0  1];
% 
% 
% ja_top = foc * verticalLines(:,1) * cos(phi_est) + foc * sin(phi_est);
% ja_bottom = (cos(theta_est)) * (verticalLines(:,1) * sin(phi_est) - cos(phi_est)) - verticalLines(:,2) * sin(theta_est);
% 
% jb_top = foc * verticalLines(:,3) * cos(phi_est) + foc * sin(phi_est);
% jb_bottom = (cos(theta_est)) * (verticalLines(:,3) * sin(phi_est) - cos(phi_est)) - verticalLines(:,4) * sin(theta_est);
% 
% 
% func_fb = (ja_top ./ ja_bottom) - (jb_top ./ jb_bottom);
% 
% 
% 
%             

% %% Manual homography warping
% rotation_theta = [   cos(theta)  0  -sin(theta);
%                         0        1        0   ;
%                      sin(theta)  0   cos(theta)];
% rotation_phi = [    1    0         0; 
%                     0 cos(phi)  sin(phi); 
%                     0 -sin(phi) cos(phi)];
%                 
% rotation = rotation_theta .* rotation_phi;
% 
% % Projective
% projection = intrinsic .* rotation;