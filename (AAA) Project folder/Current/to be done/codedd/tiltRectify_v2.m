function c = simcost_HR(x,L,K)

%% Computes the cost function of vertical line segments
% x 3X3 represents a guesstimate RECTIFYING parameter that rotate about Z-axis
% orthoX 3X3 represents a known RECTIFYING parameters  that rotate about X-axis and Y-axis
% L is 4Xn matrix, containing n line segments.


% Obtain rotation parameter for each axis
ax = x(1);
ay = x(2);
% Construct homography matrix that rotate about x-axis and y-axis
R1 = makehgtform('xrotate',ax,'yrotate',ay); R1 = R1(1:3,1:3);
Hinv = K * R1' * inv(K);
% Applied homography to all line segment(stright line equation)
Lp = Hinv'*L;
Vp = Lp(2,:);
C = (Vp).^2;
c = sum(C);