function [ x,y ] = nonConvexHull( rectangles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=round(rectangles(1:2:end,1)*1000/1000;
y=round(rectangles(2:2:end,1)*1000/1000;
for i=2:size(rectangles,2)

	x1=round(rectangles(1:2:end,i)*1000/1000;
    y1=round(rectangles(2:2:end,i)*1000/1000;
    [x,y]=polybool('+',x,y,x1,y1);
end

%%removing holes
% size(x)
% display('in non convex hull')
% size(x)
[x,y]=removeHoles(x,y);
% size(x)
% size(y)
% hulls=cell(1,0);
% a=isnan(x);
% a=find(a);
% if size(a,1)
%         xtemp=x(1:a(1)-1,:);
%         ytemp=y(1:a(1)-1,:);
%         xtemp=[xtemp,ytemp];
%     hulls=[hulls,xtemp'];
%     abegin=a(1);
%     for i=2:size(a)-1
%         xtemp=x(abegin+1:a(i)-1,:);
%         ytemp=y(abegin+1:a(i)-1,:);
%         xtemp=[xtemp,ytemp];
%         hulls=[hulls,xtemp'];
%         abegin=a(i);
%     end
%     
%         xtemp=x(a(end)+1:end,:);
%         ytemp=y(a(end)+1:end,:);
%         xtemp=[xtemp,ytemp];
%     hulls=[hulls,xtemp'];
% for i=1:size(hulls,2)
%     x1=hulls{1,i}(1,:);
%     y1=hulls{1,i}(2,:);
%     for j=1:size(hulls,2)
%         if j==i
%             continue
%         end
%         x2=hulls{1,j}(1,:);
%         y2=hulls{1,j}(2,:);
%         
%     in=inpolygon(x1,y1,x2,y2);
%     size(find(in))
%     if size(find(in),2)~=0
%         break
%     end
%     end
% end
% else
%     hulls{1,1}=[x';y'];
%     j=1;
% end
% 
% 
% x=hulls{1,j}(1,:);
%                     y=hulls{1,j}(2,:);
end

