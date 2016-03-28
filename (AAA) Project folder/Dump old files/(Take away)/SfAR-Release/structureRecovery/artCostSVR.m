function [ cost ] = artCostSVR( xp, PArt_im_c, artSeg, PAdj, talk)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cost=0; 
Kp=diag([xp(1),xp(1),1]);
    k=(size(xp,1)-1)/2;
    planes=zeros(3,k);
    for index1=1:k
        ax=xp(2*index1);ay=xp(2*index1+1);
        Rtemp=makehgtform('xrotate',ax,'yrotate',ay); Rtemp=Rtemp(1:3,1:3);
        planes(:,index1)=Rtemp'*[0;0;1];
    end

    d=findDistances(planes(1:3,:),PArt_im_c,PAdj,Kp,artSeg);
    planes=[planes;d'];
    planes(4,:)=-1*planes(4,:);

for m=1:size(PAdj,1)
        buddies=[m];
        for i=m:size(PAdj,2)
            if(PAdj(m,i)>0)
                buddies=[buddies;i];
            end
        end
        for l=2:size(buddies,1)
         part=PArt_im_c(:,artSeg(buddies(1,1),:)>0 & (artSeg(buddies(l,1),:)>0));
         pln=[planes(:,buddies(1,1)) planes(:,buddies(l,1))];
         for i=1:size(part,2)
             pq=part(:,i);
            cost=cost+getDistance(pln,pq,Kp,talk);
         end
        end
    end

end

function Distance=getDistance(pne,PArt_im_c,Kp,talk)

plane1=pne(:,1);
plane2=pne(:,2);
WStar=[plane1';plane2'];
W=null(WStar);
W(1:3,:)=W(1:3,:)./repmat(W(4,:),3,1);
W=W([1,2,3],:);

X=Kp*W;
X(1:3,:)=X(1:3,:)./repmat(X(3,:),3,1);
X=X([1,2],:);

W=X;
Distance = abs(det([W(:,2)-W(:,1),PArt_im_c(:,1)-W(:,1)]))/norm(W(:,2)-W(:,1));

if talk
figure
hold on

plot(PArt_im_c(1,1),PArt_im_c(2,1),'--gs','LineWidth',2,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','g',...
            'MarkerSize',10);

X=W;
plot([X(1,1) X(1,2)],[X(2,1) X(2,2)],'--rs','LineWidth',2,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','r',...
            'MarkerSize',10);
hold off
end

end

