function c = tiltocost_HR(x,L,K)

%% Computes the cost function of vertical line segments
% x 3X3 represents a guesstimate RECTIFYING parameter that rotate about Z-axis
% orthoX 3X3 represents a known RECTIFYING parameters  that rotate about X-axis and Y-axis
% L is 4Xn matrix, containing n line segments.


% Obtain rotation parameter for each axis
ax = x(1);
ay = x(2);

% Take the focal length, assuming square pixel
foc = K(1);
C = zeros(1,size(L,2));
for i=1: size(L,2)
	AA = foc * L(2,i) * cos(ay) + foc * sin(ay);
	AB = (L(2,i) * sin(ay) - cos(ay)) * cos(ax) - (L(1,i) * sin(ax));
	BA = foc * L(4,i) * cos(ay) + foc * sin(ay);
	BB = (L(4,i) * sin(ay) - cos(ay)) * cos(ax) - (L(3,i) * sin(ax));
	C(i) = ((AA / AB) - (BA / BB))^2;
end
c = sum(C);