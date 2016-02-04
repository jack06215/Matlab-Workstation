close all
xx=[6,45];
yy=[12,18];
dx = xx(2) - xx(1);
dy = yy(2) - yy(1);
normalxx = [ -dy, dy];
normalyy = [dx, -dx];
figure, hold on
axis([-50 50 -50 50]);
daspect([1 1 1]);
plot(xx,yy,'-', 'Color', 'Red', 'LineWidth', 2);
plot(normalxx, normalyy, '-', 'Color', 'Blue', 'LineWidth', 2);