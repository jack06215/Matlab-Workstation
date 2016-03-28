function [ result ] = myFunc_x(x,y,theta,phi,foc)
result = (foc * x * cos(theta)) + (foc * y * sin(phi) - foc * cos(phi)) * sin(theta)...
        / (-(y * sin(phi) - cos(phi)) * cos(theta) + x * sin(theta));
end

