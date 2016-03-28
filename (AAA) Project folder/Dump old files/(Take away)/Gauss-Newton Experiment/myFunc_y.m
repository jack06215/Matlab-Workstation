function [ result ] = myFunc_y(x,y,theta,phi,foc)
result = (foc * y * cos(phi) + foc * sin(phi)) / (-(y * sin(phi) - cos(phi)) * cos(theta) + x * sin(theta));
end

