% Definition of the points A and B
A = [12,65];
B = [0,60];
x = [A(1) B(1)];
y = [A(2) B(2)];
fitvars = polyfit(x, y, 1);
%% Let's start rotate the line
% Plot of the original line
plot(x,y,'Color','Red','LineWidth',3)
grid on
hold on
% for each rotation angle from 10 to 350
for a = 10:10:350
    daspect([1 1 1]);
  % Definition of the rotation matrix
  mx=[  cosd(a) -sind(a)
        sind(a) cosd(a) ];
  % Traslation and rotation of the points A and B
  x1_y1 = mx * [x;y];
  x1 = x1_y1(1,:);
  y1 = x1_y1(2,:);
  % Check for parallel line
  colorrr = 'b';
  fitvars2 = polyfit(x1, y1, 1);
  if fitvars(1) == fitvars2(1)
      colorrr = 'r';
  end
  % Plot of the rotated line
  ph = plot(x1,y1,'Color',colorrr,'LineWidth',3);
  % Here we lock our plot dimension ratio by 1:1:1 (Cuboid shape)
  
  plot(x1,y1,'o','MarkerEdgeColor', colorrr, ...
     'MarkerSize', 3, 'MarkerFaceColor',colorrr);
  pause(.005)
end
legend('Original', 'Rotated', -1)