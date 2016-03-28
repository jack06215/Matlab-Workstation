function [inliers,H]=findHinliers(H,L,t,talk)

if nargin<4
    talk=0;
end

% set up Vi and Vj
Lp = inv(H)'*L;
Vp = Lp(1:2,:);
for index=1:size(L,2)
    Vp(:,index) = Vp(:,index)/norm(Vp(:,index));
end

% calculate the cost function
C = (Vp'*Vp).^2;
% C = (C.*(1-C));
% c = sum(sum(C));

inliers = C<=t;
% inliers = inliers-diag(diag(inliers));

if talk
    fprintf(1,'inliers: %d \n',sum(sum(inliers))/2);
end