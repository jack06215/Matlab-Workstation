function vr = rotateVector(v, angle)
%ROTATEVECTOR Rotate a vector by a given angle
%
%   VR = rotateVector(V, THETA)
%   Rotate the vector V by an angle THETA, given in radians.
%
%   Example
%   rotateVector([1 0], pi/2)
%   ans = 
%       0   1
%

% precomputes angles
cot = cos(angle);
sit = sin(angle);

% compute rotated coordinates
vr = [cot * v(:,1) - sit * v(:,2) , sit * v(:,1) + cot * v(:,2)];
vr = horzcat(vr, 0);
