clc;
% load('ls.mat');
x0 = [0,0];
center = [size(img,2)/2; size(img,1)/2];
options = optimset('Algorithm', 'levenberg-marquardt',...
                 'Display', 'iter',... 
                 'MaxIter', 2000,... 
                 'TolFun', 10^-20,... 
                 'TolX', 10^-10,... 
                 'MaxFunEvals',10^20,...
                 'LargeScale', 'off');

             
ls_center = ls - repmat(center,2,size(ls,2));
% L = twopts2L(ls_center);
% R = makehgtform('xrotate',x(1),'yrotate',x(2));
% R = R(1:3,1:3);
% H = K * R' * inv(K);
% Lp = H'*L;
% Vp = Lp(1:2,:);
% Vp=Vp./repmat(sqrt(sum(Vp.^2)),2,1);
% vertVector = [0,1];
% C = zeros(size(Vp,2),1);
% for i=1:size(Vp,2)
%     C(i) = vertVector * Vp(:,i);
% end

K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
f = @(x0)objCostFun(x0,ls_center,K);    
[x, fval] = lsqnonlin(f,x0,[0,-pi/2],[pi/2,0],options);

%%
R = makehgtform('xrotate',x(1),'yrotate',x(2));
R = R(1:3,1:3);
H = K * R' * inv(K);
ls_A = [ls(1:2,:); ones(1,size(ls,2))];
ls_B = [ls(3:4,:); ones(1,size(ls,2))];

ls_A_new = H'*ls_A; 
ls_A_new = ls_A_new ./ [ls_A_new(3,:);ls_A_new(3,:);ls_A_new(3,:)];

ls_B_new = H'*ls_B;
ls_B_new = ls_B_new ./ [ls_B_new(3,:);ls_B_new(3,:);ls_B_new(3,:)];

ls_new = [ls_A_new(1:2,:); ls_B_new(1:2,:)];