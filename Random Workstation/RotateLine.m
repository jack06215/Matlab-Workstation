%% Create a reference point
% Definition of the L1 parameter
L1 = 10;
% Definition of the points A and B
A = [1,5];
B = [2,6];
x = [A(1) B(1)];
y = [A(2) B(2)];
% Definition of the offset
x_offset=[x(1) 0 x(1)];
y_offset=[y(1) 0 50];

%% Let's start rotate the line
for k = 1:3
   figure
   % Plot of the original line
   plot(x,y,'Color','Red','LineWidth',2)
   grid on
   hold on
   % for each rotation angle from 10 to 350
   for a = 10:10:350
      % Definition of the rotation matrix
      mx=[  cosd(a) -sind(a)
            sind(a) cosd(a) ];
      % Traslation and rotation of the points A and B
      x1_y1 = mx * [x - x_offset(k);y - y_offset(k)];
      x1 = x1_y1(1,:);
      y1 = x1_y1(2,:);
      % Plot of the rotated line
      ph = plot(x1+x_offset(k),y1+y_offset(k),'Color','Blue','LineWidth',2);
      
      % Here we lock our plot dimension ratio by 1:1:1 (Cuboid shape)
      daspect([1 1 1])
      plot(x1+x_offset(k),y1+y_offset(k),'o','MarkerEdgeColor', 'b', ...
         'MarkerSize', 3, 'MarkerFaceColor','b')
      pause(.005)
   end
   legend('Original', 'Rotated', -1)
end