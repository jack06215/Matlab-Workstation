function [ seg ] = giveNumberCorners( xPoly,yPoly,rect,no )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% pts1=rect(1:2,:);
% pts2=rect(3:4,:);
% pts3=rect(5:6,:);
% pts4=rect(7:8,:);
% seg=ones(1,size(rect,2));
seg=zeros(1,size(rect,2));
for i=1:4
    pts=rect((2*i-1):(2*i),:);
segTemp=inpolygon(pts(1,:),pts(2,:),xPoly,yPoly);
seg=seg+segTemp;
end
seg=seg>=no;

end

