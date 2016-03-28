function [x,y,newx]=giveRectangle(intx,art,no,H)

artH=[art(1:2,1),art(3:4,1)];
artH=[artH;ones(1,size(artH,2))];
    artH=H*artH;
    artH=artH./repmat(artH(3,:),3,1);
    artH=artH(1:2,:);
    intxH=H*[intx;ones(1,1)];
    intxH=intxH./repmat(intxH(3,:),3,1);
    intxH=intxH(1:2,:);
    if no==1
        vecArt=artH(:,2)-artH(:,1);
    else
        vecArt=artH(:,1)-artH(:,2);
    end
%     intxH
%     vecArt
        newxH=intxH+vecArt;
    newx=H\[newxH;1];
    newx=newx./repmat(newx(3,:),3,1);
    newx=newx(1:2,:);

    x=[art(1,1),art(3,1),intx(1,:),newx(1,:)];
    y=[art(2,1),art(4,1),intx(2,:),newx(2,:)];
    ind=convhull(x,y);
    x=x(ind);
    y=y(ind);
    
    %%
%     pxy=[artH,intxH,newxH]
% %     pxy=H*[x;y;ones(1,size(x,2))];
% %     pxy=pxy./repmat(pxy(3,:),3,1);
%     figure,axis equal
%     hold on
%     plot(pxy(1,:),pxy(2,:),'*-k','markersize',10);
%     hold off
    
    %%%
end