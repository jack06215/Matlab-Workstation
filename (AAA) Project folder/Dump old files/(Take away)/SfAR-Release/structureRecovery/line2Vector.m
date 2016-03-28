function [ mat ] = line2Vector( matrix )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
mat=matrix(3:4,:)-matrix(1:2,:);
n = ((mat(1,:).^2 + mat(2,:).^2).^(1/2));
for i=1:size(mat,2)
mat(:,i)=mat(:,i)/n(:,i);
% mat=abs(mat);
end
end

