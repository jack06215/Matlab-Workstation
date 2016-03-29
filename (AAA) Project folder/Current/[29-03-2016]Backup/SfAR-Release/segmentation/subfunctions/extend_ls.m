function [newls,BB]=extend_ls(LS,lsnum,BB,talk,dthresh)

if nargin<1
    error('at least two arguments are required');
end
if nargin<3
    BB=[ min([LS(1,:),LS(3,:)])-10;...
         min([LS(2,:),LS(4,:)])-10;...
         max([LS(1,:),LS(3,:)])+10;...
         max([LS(2,:),LS(4,:)])+10];
end
if isempty(BB)
    BB=[ min([LS(1,:),LS(3,:)]);...
         min([LS(2,:),LS(4,:)]);...
         max([LS(1,:),LS(3,:)]);...
         max([LS(2,:),LS(4,:)])];
end
if nargin<4 || isempty(talk)
    talk=0;
end
if nargin<5
    dthresh=inf;
end

% take out the target line segment
ls=LS(:,lsnum);
LS(:,lsnum)=[];
n=size(LS,2);
if talk
    display(lsnum);
end

% add bounding box as line segments
LS=[ LS,...
    [BB(1);BB(2);BB(1);BB(4)],...
    [BB(1);BB(2);BB(3);BB(2)],...
    [BB(3);BB(4);BB(1);BB(4)],...
    [BB(3);BB(4);BB(3);BB(2)] ];

% % check if the target line is aligned with an axis,
% % then solve a rotated version
% if any(abs(ls(1:2)-ls(3:4))<0)
%     disp('Rotating');
%     rotated=1;
%     R=[cosd(45),-sind(45);sind(45),cosd(45)];
%     LS=[R*LS(1:2,:); R*LS(3:4,:)];
%     ls=[R*ls(1:2);R*ls(3:4)];
% else
%     rotated=0;
% end


% compute alpha and beta parametrizations for the intersection points
% by solving the linear system
alpha=zeros(1,size(LS,2));
beta=alpha;
for index=1:size(LS,2)
    A=[ls(1:2)-ls(3:4), -LS(1:2,index)+LS(3:4,index)];
    b=-ls(3:4)+LS(3:4,index);
    x=A\b;
    if all(isfinite(x))
        alpha(index)=x(1);
        beta(index)=x(2);
    else
        % put values that will be ignored in future comparisons
        alpha(index)=0.5;
        beta(index)=inf;
    end
end
if talk
%     display(A);
%     display(b');
%     display(x);
%     display(alpha);
%     display(beta);
end

% select the line segments with 0<beta<1 (only these intersect the target line)
index=beta<1 & beta>0;
% pick the smallest alpha>1 and largest alpha<0
index1=index & (alpha>1);
if sum(index1)
    alpha1=min([alpha(index1),dthresh]);
else
    alpha1=1;
end
index2=index & (alpha<0);
if sum(index2)
    alpha2=max([alpha(index2),-dthresh]);
else
    alpha2=0;
end
% construct the new line segment
newls=[ alpha1*ls(1:2)+(1-alpha1)*ls(3:4);...
        alpha2*ls(1:2)+(1-alpha2)*ls(3:4)];

% % if the plane had to be rotated, rotate it back
% if rotated
%     R=R';
%     LS=[R*LS(1:2,:); R*LS(3:4,:)];
%     ls=[R*ls(1:2);R*ls(3:4)];
%     newls=[R*newls(1:2);R*newls(3:4)];
% end
    
LS=LS(:,1:n);
if talk
    display(newls);
    axis equal
    visualizeMPLSimage(LS,ones(1,n));
    hold on;
    rectangle('position',[BB(1),BB(2),BB(3)-BB(1),BB(4)-BB(2)]);
    plot(newls([1,3]),newls([2,4]),'b:','linewidth',2);
    plot(ls([1,3]),ls([2,4]),'g-','linewidth',3);
    hold off;
end