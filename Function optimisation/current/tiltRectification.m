function [x,fval] = tiltRectification(ls_center,K,x0)
%TILTRECTIFY - Image tilt rectification
%   Given an input image and a set of vertical line segments, this fuction 
%   perform tilt rectification so that all vertical line segments will have
%   vanishing at (close to) point at infinity.
%--------------------------------------------------------------------------
%   INPUT
%       x0        - 1x2 of initial guess for the angle alpha and beta.
%       ls_center - 4xn of centered line segment defined by two end
%                   points.
%       K         - 3x3 of camera intrnsic without image center infromation.
%   OUTPUT
%       x         - 1x2 of final result of estimate angle alpha and beta.
%--------------------------------------------------------------------------
if nargin < 3
    x0 = [0,0];
end

options = optimset('Algorithm', 'levenberg-marquardt',...
                 'Display', 'iter',... 
                 'MaxIter', 2000,... 
                 'TolFun', 10^-20,... 
                 'TolX', 10^-10,... 
                 'MaxFunEvals',10^20,...
                 'LargeScale', 'off');

objFun = @(x0)tiltcost_HR(x0,ls_center,K);   
[x, fval] = lsqnonlin(objFun,x0,[],[],options);

end

function C = tiltcost_HR(x0,ls_center,K)
% Convert line segment into line equation of the form ax+by+c=0
L = twopts2L(ls_center);
% Build homography matrix
R = makehgtform('xrotate',x0(1),'yrotate',x0(2));
R = R(1:3,1:3);
H = K * R'/K;
% Perform warping, take the directional vector and normalise to length of 1
Lp = H'*L;
Vp = Lp(1:2,:);
Vp=Vp./repmat(sqrt(sum(Vp.^2)),2,1);
vertVector = [0,1]; % Defined a vertical line with length of 1
% Calculate the total cost for each line segment
C = zeros(size(Vp,2),1);
for i=1:size(Vp,2)
    C(i) = vertVector * Vp(:,i);
end
end

function Lout = twopts2L(L)

% preprocess L
if size(L,1)==6
    L(1:3,:)=L(1:3,:)./repmat(L(3,:),3,1);
    L(4:6,:)=L(4:6,:)./repmat(L(6,:),3,1);
elseif size(L,1)==4
    L=[L(1:2,:);ones(1,size(L,2));L(3:4,:);ones(1,size(L,2))];
else
    error('L must be 4XN or 6XN for N 2D line segments');
end

Lout=zeros(3,size(L,2));
for index=1:size(L,2)
    Lout(:,index)=fitline([L(1:3,index),L(4:6,index)]);
end
end

function B = fitline(X)
% Normalise the w dimension (in terms of prespective coordinate system)
if size(X,1)==3
    X=X./repmat(X(3,:),3,1);
    X=X(1:2,:);
end

  [rows,npts] = size(X);    
  
  if rows ~=2
    error('data is not 2D');
  end
  
  if npts < 2
    error('too few points to fit line');
  end
  
  % Set up constraint equations of the form  AB = 0,
  % where B is a column vector of the line coefficients
  % in the form   b(1)*X + b(2)*Y + b(3) = 0.
  
  A = [X' ones(npts,1)]; % Build constraint matrix
  
  if npts == 2             % Pad A with zeros
    A = [A; zeros(1,3)]; 
  end

  [u,d,v] = svd(A);        % Singular value decomposition.
  B = v(:,3);              % Solution is last column of v.
end 