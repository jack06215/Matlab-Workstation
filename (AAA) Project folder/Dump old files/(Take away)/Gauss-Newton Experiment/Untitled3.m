x = 125;
y = 144;
% x = x / sqrt(norm(x,y));
% y = y / sqrt(norm(x,y));
theta = 0;
phi = 0;
foc = 1;

x_new = myFunc_x(x,y,theta,phi,foc);
y_new = myFunc_y(x,y,theta,phi,foc);
if (x == x_new && y == y_new)
    disp(['No rotated! ', ' theta = ', num2str(theta), ', phi = ', num2str(phi)]);
else
    disp(['Rotated ', ' theta = ', num2str(theta), ', phi = ', num2str(phi)]);
    disp(['X: ', ' x = ', num2str(x), ', x_new = ', num2str(x_new)]);
    disp(['Y: ', ' y = ', num2str(y), ', y_new = ', num2str(y_new)]);
end
xTheta_result = myFunc_xTheta(x,y,theta,phi,foc);
xPhi_result = myFunc_xPhi(x,y,theta,phi,foc);
yTheta_result = myFunc_yTheta(x,y,theta,phi,foc);
yPhi_result = myFunc_yPhi(x,y,theta,phi,foc);
