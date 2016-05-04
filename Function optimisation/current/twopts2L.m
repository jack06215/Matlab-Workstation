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