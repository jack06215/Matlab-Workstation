function [ x,y ] = extendRectangles( art,artOther,goodquads2,rsegs,pindex1,no )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%%

%create polygon
allPts=[goodquads2(1:2,:),goodquads2(3:4,:),goodquads2(5:6,:),goodquads2(7:8,:)];
inds=convhull(allPts(1,:),allPts(2,:));
xCon=allPts(1,inds);
yCon=allPts(2,inds);
acurr=[art(1:2,1),art(3:4,1)];
Pcurr=cutpolygon([xCon; yCon]',acurr',no);
Pcurr=Pcurr';
%%

%get US and THEM
us=goodquads2(:,rsegs(pindex1,:));
them=goodquads2(:,~rsegs(pindex1,:));

%check which US to extend
segUs=giveNumberCorners(Pcurr(1,:),Pcurr(2,:),us,4);
us=us(:,segUs);

%check which them to check for conflicts with
segThem=giveNumberCorners(Pcurr(1,:),Pcurr(2,:),them,3);
them=them(:,segThem);
themLines=[them(1:4,:),them(3:6,:),them(5:8,:),[them(7:8,:);them(1:2,:)]];
%%
if size(us,2)==0
us=goodquads2(:,rsegs(pindex1,:));
quadNew=[us];
[ x,y ] = nonConvexHull( quadNew );
return
end
%get extended lines us
% size(us)
lines=giveRectInt(art,us);
%%

%intersect extended lines us with them
out=lineSegmentIntersect(themLines',lines(1:4,:)');
seg1=out.intAdjacencyMatrix;
seg1=sum(seg1);
out=lineSegmentIntersect(themLines',lines(5:8,:)');
seg2=out.intAdjacencyMatrix;
seg2=sum(seg2);
segInt=seg1+seg2;
segInt=segInt>0;
% size(segInt)
% size(lines)
linesRef=lines(:,~segInt);
%%

%extend art to boundary
artExt=extendArt2Bound(goodquads2,artOther);

%intersect with artOthers 
segInt=zeros(1,size(linesRef,2));
for i=1:size(artExt,2)
    artEx=artExt(:,i);
out=lineSegmentIntersect(artEx',linesRef(1:4,:)');
seg1=out.intAdjacencyMatrix;
out=lineSegmentIntersect(artEx',linesRef(5:8,:)');
seg2=out.intAdjacencyMatrix;
segInt=segInt+seg1+seg2;
end
segInt=segInt>0;
linesRef2=linesRef(:,~segInt);
%%

%make polygons out of linesRef2
for i=1:size(linesRef2,2)
    xtemp=linesRef2(1:2:end,i)';
    ytemp=linesRef2(2:2:end,i)';
    
    if xtemp(1,1)==xtemp(1,3) && ytemp(1,1)==ytemp(1,3)
        
    temp=zeros(8,1);
    temp(1:2:end,:)=xtemp';
    temp(2:2:end,:)=ytemp';
    linesRef2(:,i)=temp;
    else
    indR=convhull(xtemp,ytemp);
    xtemp=xtemp(indR);
    ytemp=ytemp(indR);
    if (numel(indR>4))
        xtemp=xtemp(1,1:end-1)';
        ytemp=ytemp(1,1:end-1)';
    end;
    temp=zeros(8,1);
    temp(1:2:end,:)=xtemp;
    temp(2:2:end,:)=ytemp;
    linesRef2(:,i)=temp;
    end
end
%%

%take union
us=goodquads2(:,rsegs(pindex1,:));
quadNew=[linesRef2,us];
[ x,y ] = nonConvexHull( quadNew );
end

