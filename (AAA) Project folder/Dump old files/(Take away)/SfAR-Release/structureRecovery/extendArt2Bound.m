function artEx=extendArt2Bound(goodquads2,artOther)
allPts=[goodquads2(1:2,:),goodquads2(3:4,:),goodquads2(5:6,:),goodquads2(7:8,:)];
inds=convhull(allPts(1,:),allPts(2,:));
xCon=allPts(1,inds);
yCon=allPts(2,inds);
artEx=zeros(size(artOther));
for i=1:size(artOther,2)
art1=artOther(:,i);
%  art1=[257.6328;  139.7506;  604.5943;  141.5568]+200;
acurr=[art1(1:2,1),art1(3:4,1)];
Pcurr1=cutpolygon([xCon; yCon]',acurr',1);
Pcurr1=Pcurr1';
Pcurr1=[Pcurr1(:,1:end-1);Pcurr1(:,2:end)];
artMC=giveMAndC(art1);
pMC=giveMAndC(Pcurr1);
artMC=repmat(artMC,1,size(pMC,2));
diff=artMC-pMC;
diff=abs(diff);
diff=sum(diff);
[~,ind]=min(diff);
artEx(:,i)=Pcurr1(:,ind(1,1));
end
end