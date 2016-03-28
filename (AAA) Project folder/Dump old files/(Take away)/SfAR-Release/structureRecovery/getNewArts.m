function [newArts,newSeg]=getNewArts(planes, artSeg, PArt_im_c,Kp)
planes(4,:)=-1*planes(4,:);
newArts=zeros(2,0);
newSeg=zeros(size(artSeg,1),0);
for m=1:size(planes,2)
        buddies=zeros(0,1);
        for n=m:size(planes,2)
            for l=1:size(artSeg,2)
                if artSeg(m,l)>0
                    if artSeg(n,l)>0
                        buddies=[buddies;n];
                        break
                    end
                end
            end
        end 
        for l=2:size(buddies,1)
         part=PArt_im_c(:,artSeg(buddies(1,1),:)>0 & (artSeg(buddies(l,1),:)>0));
%          buddies
         segNew=zeros(size(artSeg,1),size(part,2));
         segNew([buddies(1,1),buddies(l,1)],:)=1;
         pln=[planes(:,buddies(1,1)) planes(:,buddies(l,1))];
         C=getArts(pln,part,Kp,1);
         newArts=[newArts,C];
         newSeg=[newSeg,segNew];
        end
end
end
function C=getArts(pne,PArt_im_c,Kp,talk)
% flag=1;
% if size(PArt_im_c,2)<2
%     flag=0;
%     return
% end
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

m1=(W(2,2)-W(2,1))/(W(1,2)-W(1,1));
m2=(PArt_im_c(2,2)-PArt_im_c(2,1))/(PArt_im_c(1,2)-PArt_im_c(1,1));
c1=W(2,1)-W(1,1)*m1;
c2=PArt_im_c(2,2)-PArt_im_c(1,2)*m2;

A=[-1*m1,1;-1*m2,1];
B=[c1;c2];

int=A\B;

B1=PArt_im_c(:,2)-int;
% PArt_im_c(:,1);
B2=PArt_im_c(:,1)-int;
% PArt_im_c(:,2);
A=(W(:,1)-int)/norm(W(:,1)-int);

C1=dot(B1,A);
C1=int+C1*A;
C2=dot(B2,A);
C2=int+C2*A;
C=[C1,C2];
talk=0;
if talk
figure
hold on

plot([PArt_im_c(1,:)],[PArt_im_c(2,:)],'--gs','LineWidth',2,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','g',...
            'MarkerSize',10);

X=W;
plot([X(1,:)],[X(2,:)],'--rs','LineWidth',2,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','r',...
            'MarkerSize',10);
 plot([C(1,:)],[C(2,:)],'--bs','LineWidth',2,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','b',...
            'MarkerSize',10);

hold off
end

end