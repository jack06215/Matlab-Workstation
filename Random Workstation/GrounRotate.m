%% Get an image
scene_image = imread('Sample Images\fig2.jpg');
object_image = imread('Sample Images\fig1.jpg');
%% 1. Define Ground Ref & A 2 from images
%-----------------------------------------------------------------------------------------------
% Define reference ground
figure;
imshow(scene_image);
hold on;
[PtRefX,PtRefY] = getpts;
groundRef_X1Y1 = [PtRefX(1), PtRefY(1), 0];
groundRef_X2Y2 = [PtRefX(2), PtRefY(2), 0];
groundRef_Run = PtRefX(2) - PtRefX(1);
groundRef_Rise = PtRefY(2) - PtRefY(1);
% Draw our defined lines
plot(groundRef_X1Y1(1),groundRef_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
plot(groundRef_X2Y2(1),groundRef_X2Y2(2),'o','Color','Yellow', 'LineWidth', 3);
line(PtRefX,PtRefY, 'Color', 'Blue', 'LineWidth', 3);
%-----------------------------------------------------------------------------------------------
% Define ground A
figure;
imshow(object_image);
hold on;
[PtGndAX,PtGndAY] = getpts;
groundA_X1Y1 = [PtGndAX(1), PtGndAY(1), 0];
groundA_X2Y2 = [PtGndAX(2), PtGndAY(2), 0];
groundA_Run = PtGndAX(2) - PtGndAX(1);
groundA_Rise = PtGndAY(2) - PtGndAY(1);
% Draw our defined lines
plot(groundA_X1Y1(1),groundA_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
plot(groundA_X2Y2(1),groundA_X2Y2(2),'o','Color','Yellow', 'LineWidth', 3);
line(PtGndAX,PtGndAY, 'Color', 'Red', 'LineWidth', 3);
hold off;
%% 2. Map Ground ref and Ground A to the standard Cartesian coordinate system
origin = [0, 0, 0];
ref = [100, 0, 0];
figure;
hold on;
daspect([1 1 1]);

plot(ref(1), ref(2), 'o', 'color', 'yellow', 'linewidth', 3);
L_Ref = line([origin(1) 100], [origin(2) ref(2)], 'color', 'yellow', 'linewidth', 5);

plot(groundRef_Run, groundRef_Rise, 'o', 'color', 'r', 'linewidth', 3);
L_groundRef = line([origin(1) groundRef_Run], [origin(2) groundRef_Rise], 'color', 'blue', 'linewidth', 3);

plot(groundA_Run, groundA_Rise, 'o', 'color', 'r', 'linewidth', 3);
L_groundA = line([origin(1) groundA_Run], [origin(2) groundA_Rise], 'color', 'red', 'linewidth', 3);

fitRef = polyfit([origin(1), ref(1)], [origin(2), ref(2)], 1);
fitGndRef = polyfit([origin(1), groundRef_Run], [origin(2), groundRef_Rise], 1);
fitGndA = polyfit([origin(1), groundA_Run], [origin(2), groundA_Rise], 1);
%% 3. Calculate angle difference
angleGndRef = atan((fitGndRef(1) - fitRef(1)) / (1 + (fitGndRef(1)* fitRef(1))));
disp(['Angle Ref-GndRef difference ', num2str(rad2deg(angleGndRef)), ' degree']);

angleGndA = atan((fitGndA(1) - fitRef(1)) / (1 + (fitGndA(1)* fitRef(1))));
disp(['Angle Ref-GndA difference ', num2str(rad2deg(angleGndA)), ' degree']);

angle_diff = angleGndA - angleGndRef;
disp(['Angle GndRef-GndA difference is ', num2str(rad2deg(angle_diff)), ' degree']);

legend([L_Ref, L_groundRef, L_groundA], 'Ref', 'Ground Ref', 'Ground A');