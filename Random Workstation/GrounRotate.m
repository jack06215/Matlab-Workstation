%% Get an image
scene_image = imread('Sample Images\fig2.jpg');
imshow(scene_image);
hold on
%% Get a reference & moving vector
% Reference vector
[vecA,vecB] = getpts;
plot(vecA(1),vecB(1),'*','color','r');
plot(vecA(2),vecB(2),'*','color','r');
line(vecA,vecB, 'Color', 'b', 'LineWidth', 3);
X_AB = [vecA(1) vecB(1)];
Y_AB = [vecA(2) vecB(2)];
fitvarsAB = polyfit(X_AB, Y_AB, 1);
% Moving vector
[vecC, vecD] = getpts;
plot(vecC(1),vecD(1),'*','color','r');
plot(vecC(2),vecD(2),'*','color','r');
line(vecC,vecD, 'Color', 'green', 'LineWidth', 3);
%% Construct vectors
vectorAB = [horzcat((vecB(2)-vecB(1)), (vecA(2)-vecA(1))), 0];
vectorCD = [horzcat((vecD(2)-vecD(1)), (vecC(2)-vecC(1))), 0];
%% Calculate angle between reference vector and the vector
RotateAngle = atan2(norm(cross(vectorAB, vectorCD)), dot(vectorAB,vectorCD));
disp(['Rotate about ', num2str(rad2deg(RotateAngle)), ' degree']);
%% Rotate moving vector
AAA = rotateVector(vectorCD, rad2deg(RotateAngle));
BBB = rotateVector(vectorCD, rad2deg(-RotateAngle));
disp(cross(vectorAB, AAA));
disp(cross(vectorAB, BBB));