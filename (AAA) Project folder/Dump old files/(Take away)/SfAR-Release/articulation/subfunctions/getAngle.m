function a=getAngle(planes,line,Kp,tolk)
if nargin<4
    tolk=0;
end
%planes is basically PI concatinated columnwise

line=[line(1:3,:),line(4:6,:)];         %put both end points of art line in columns
planes(4,:)=-1*planes(4,:);             %negative the D part
plane1=planes(:,1);
plane2=planes(:,2);
WStar=[plane1';plane2'];
W=null(WStar);
W(1:3,:)=W(1:3,:)./repmat(W(4,:),3,1);
W=W([1,2,3],:);

X=Kp*W;
X(1:3,:)=X(1:3,:)./repmat(X(3,:),3,1);
X=X([1,2],:);

if tolk
%     X
figure
hold on
plot(X(1,:),X(2,:),'--rs','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','r',...
                       'MarkerSize',10)
plot(line(1,:),line(2,:),'--gs','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',10)
hold off
pause
end

X=X(:,2)-X(:,1);
% if tolk
%     line
% end
line=line(:,2)-line(:,1);
line=line(1:2,:);
a=line'*X;
a=a/(norm(line)*norm(X));
a=sqrt(a^2);
end