function [ result ] = myFunc_yPhi(x,y,theta,phi,foc)
result = - (foc*cos(phi) - foc*y*sin(phi))/(cos(theta)*(cos(phi) - y*sin(phi)) + x*sin(theta)) - (cos(theta)*(foc*sin(phi) + foc*y*cos(phi))*(sin(phi) + y*cos(phi)))/(cos(theta)*(cos(phi) - y*sin(phi)) + x*sin(theta))^2;
end

