function [ mAndC ] = giveMAndC( L )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
mAndC=[];
for i=1:size(L,2)
x1=L(1,i);
y1=L(2,i);
x2=L(3,i);
y2=L(4,i);
m=(y2-y1)/(x2-x1);
c=y2-m*x2;
mAndC=[mAndC,[m;c]];
end
end

