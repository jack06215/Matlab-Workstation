% Definition of the L1 parameter
L1=13;
% Definition of the points A and B
A=[L1,20]
B=[L1,100]
x=[A(1) B(1)];
y=[A(2) B(2)];
% Definition of the offset
x_offset=[x(1) 0 x(1)];
y_offset=[y(1) 0 50];
for k=1:3
   figure
   % Plot of the original line
   plot(x,y,'r','linewidth',2)
   grid on
   hold on
   for a=10:10:350
      % Definitin of the rotation angle
      % a=45;
      t=a*pi/180;
      % Definition of the rotation matrix
      mx=[ ...
         cos(t) -sin(t)
         sin(t) cos(t)
         ];
      % Traslation and rotation of the points A and B
      x1_y1=mx*[x - x_offset(k);y - y_offset(k)]
      x1=x1_y1(1,:);
      y1=x1_y1(2,:);
      % Plot of the rotated line
      ph=plot(x1+x_offset(k),y1+y_offset(k),'b','linewidth',2)
      daspect([1 1 1])
      % xlim([-100 30])
      % ylim([-80 120])
      plot(x1+x_offset(k),y1+y_offset(k),'o','markeredgecolor','b', ...
         'markersize',3,'markerfacecolor','b')
      pause(.05)
      % delete(ph)
   end
   legend('Original','Rotated',-1)
end