% x = 2;
% 
% xv = [-x;x;x;-x;-x];
% yv = [x;x;-x;-x;x];
% rng default
% xq = randn(250,1);
% yq = randn(250,1);
[in,on] = inpolygon(xq,yq,xv,yv);
figure

plot(xv,yv) % polygon
axis equal

hold on
plot(xq(in),yq(in),'r+') % points inside
plot(xq(~in),yq(~in),'bo') % points outside
hold off