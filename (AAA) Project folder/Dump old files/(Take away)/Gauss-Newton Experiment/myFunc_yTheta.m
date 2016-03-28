function [ result ] = myFunc_yTheta(x,y,theta,phi,foc)
result = -((foc*sin(phi) + foc*y*cos(phi))*(sin(theta)*(cos(phi) - y*sin(phi)) - x*cos(theta)))/(cos(theta)*(cos(phi) - y*sin(phi)) + x*sin(theta))^2;
end

