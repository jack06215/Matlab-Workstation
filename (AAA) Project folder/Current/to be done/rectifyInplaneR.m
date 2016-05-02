function [H,x,fval] = rectifyInplaneR(L,K,x0)

% L is the 3XN matrix of lines in P2
% K is the intrinsic camera matrix
% A is the symmetric line adjacency matrix, A(i,j)=1 if planes i,j are
%   [probably] adjacent, 0 otherwise.
% H 3X3 is the rectifying homography constructed out of a given K and
% unknown plane orientation (2 dof)

if nargin<3
    x0 = [0,0]; % rotation parameter about z-axis
end

options=optimset( 'Display', 'on', 'MaxIter', 100, 'TolFun', 10^-20, 'TolX', 10^-10, 'MaxFunEvals',10^20, 'LargeScale', 'off');

[x, fval] = fminunc(@simcost_HR,x0,options,L,K);
ax=x(1); ay=x(2);
R=makehgtform('xrotate',ax,'yrotate',ay); R=R(1:3,1:3);
H=inv(K*R'*inv(K));