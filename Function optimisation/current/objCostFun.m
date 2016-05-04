function C = objCostFun(x0,ls_center,K)

L = twopts2L(ls_center);
R = makehgtform('xrotate',x0(1),'yrotate',x0(2));
R = R(1:3,1:3);
H = K * R' * inv(K);
Lp = H'*L;
Vp = Lp(1:2,:);
Vp=Vp./repmat(sqrt(sum(Vp.^2)),2,1);
vertVector = [0,1];
C = zeros(size(Vp,2),1);
for i=1:size(Vp,2)
    C(i) = vertVector * Vp(:,i);
end
% ls_A = [ls(1:2,:); ones(1,size(ls,2))];
% ls_B = [ls(3:4,:); ones(1,size(ls,2))];
% ax = x0(1);
% ay = x0(2);
% R = makehgtform('xrotate', ax, 'yrotate', ay);
% R = R(1:3,1:3);
% Hinv = K * R' * inv(K);
% 
% ls_A_new = Hinv'*ls_A; 
% ls_A_new = ls_A_new ./ [ls_A_new(3,:);ls_A_new(3,:);ls_A_new(3,:)];
% 
% ls_B_new = Hinv'*ls_B;
% ls_B_new = ls_B_new ./ [ls_B_new(3,:);ls_B_new(3,:);ls_B_new(3,:)];
% 
% C = (ls_A_new - ls_B_new).^2;
% % c = sum(C(1,:));
% c = C(1,:)';
end

