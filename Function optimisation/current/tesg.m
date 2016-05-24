close all;
clear;

line1=[0,10,5,10]';
line2=[10,0,10,5]';
line3=[0,0,5,5]';
line = [line1,line2,line3];

L = twopts2L(line);

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