% Definition of the points A and B (Vector AB)
PosA_X = [130,130];
PosB_Y = [147,150];
X_AB = [PosA_X(1) PosB_Y(1)];
Y_AB = [PosA_X(2) PosB_Y(2)];
fitvarsAB = polyfit(X_AB, Y_AB, 1);

% Definition of the points C and D (Vector CD)
PosC_X = [25,3];
PosD_Y = [20,1];
X_CD = [PosC_X(1) PosD_Y(1)];
Y_CD = [PosC_X(2) PosD_Y(2)];
fitvarsCD = polyfit(X_CD, Y_CD, 1);
%plot(X_AB,Y_AB,'Color','Red','LineWidth',3);
hold on;
plot(X_CD,Y_CD,'Color','Blue','LineWidth',3);
a = 1;
mx=[  cosd(a) -sind(a)
sind(a) cosd(a) ];
% Traslation and rotation of the points A and B
x1_y1 = mx * [X_CD;Y_CD];
x1 = x1_y1(1,:);
y1 = x1_y1(2,:);
% Plot of the rotated line
ph = plot(x1,y1,'Color','Blue','LineWidth',3);
% Here we lock our plot dimension ratio by 1:1:1 (Cuboid shape)

plot(x1,y1,'o','MarkerEdgeColor', 'Blue', ...
'MarkerSize', 3, 'MarkerFaceColor','Blue');