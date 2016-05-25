close all;
clear;
addpath(genpath('.'));

% 4 line segments defined
line1=[0;10;5;10];
line2=[10;0;10;5];
line3=[0;0;7.5;0];
line4=[-5;-pi;-5;13];
ls = [line1,line4,line3,line2];

% Sort out line segments
L = twopts2L(ls);
ref = repmat(-eps,(size(L(1:2,:))));
diff = abs(L(1:2,:)) - ref;
[~,ind] = min(diff,[],1);
[~,ind] = sort(ind);
L_sort = L(:,ind);

combinations = [1,3;...
                1,4;...
                2,3;...
                2,4;];

intpt = zeros(2,4);            
for i=1:size(combinations,1)
    lv1 = L_sort(:,combinations(i,1));
    lv2 = L_sort(:,combinations(i,2));
    tmp = az_hcross(lv1,lv2);
    intpt(:,i) = tmp(1:2);
end




limits = [-20,20,-20,20];
color = hsv(4);
figure,hold on;
for i=1:size(ls,2)
    plot(ls([1,3],i),ls([2,4],i),'Color',color(i,:),'LineWidth',2);
    plot(intpt(1,i),intpt(2,i),'x','Color','black','LineWidth',2);
end
axis(limits);
% A=[-(line1(2,2)-line1(1,2)),(line1(2,1)-line1(1,1));
% -(line2(2,2)-line2(1,2)),(line2(2,1)-line2(1,1));
% -(line3(2,2)-line3(1,2)),(line3(2,1)-line3(1,1))];
% 
% 
% b=[(line1(1,1)*A(1,1))+ (line1(1,2)*A(1,2));
%    (line2(1,1)*A(2,1))+ (line2(1,2)*A(2,2));
%    (line3(1,1)*A(3,1))+ (line3(1,2)*A(3,2))];
% 
% [U D V] = svd(A)
% bprime = U'*b
% 
% y=[bprime(1)/D(1,1);bprime(2)/D(2,2)]
% 
% x=V*y
% 
% figure, hold on;
% plot(line1(1,:),line1(2,:),'color',[1,0,0],'LineWidth',2);
% plot(line2(1,:),line2(2,:),'color',[1,0,0],'LineWidth',2);
% plot(x(:),y(:),'x','color',[0,1,0],'LineWidth',3);