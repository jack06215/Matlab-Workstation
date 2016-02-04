function [ int ] = lsIntersect( ind,LS )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
int=zeros(2,size(ind,2));
for i=1:size(int,2)
    
    L1 = createLine(LS(1:2,ind(1,i))',LS(3:4,ind(1,i))');
    L2 = createLine(LS(1:2,ind(2,i))',LS(3:4,ind(2,i))');
%     line = createLine()
x =...
intersectLines(L1,L2);
int(1,i)=x(1,1);
int(2,i)=x(1,2);

% return
% [x,y]=polyxpoly([LS(1,ind(1,i)) LS(3,ind(1,i))],...
%     [LS(2,ind(1,i)) LS(4,ind(1,i))],...
%     [LS(1,ind(2,i)) LS(3,ind(2,i))],...
%     [LS(2,ind(2,i)) LS(4,ind(2,i))])
end
end

