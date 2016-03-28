function [artAll]=giveArtAll(art,H)
% display('here')
art=[art(1:2,1),art(3:4,1)];
art=[art;ones(1,size(art,2))];
artH=H*art;
artH=artH./repmat(art(3,:),3,1);
artH=artH(1:2,:);
art=art(1:2,:);
Lout = twopts2L([artH(:,1);artH(:,2)]);
p=artH(:,1)+10000*Lout(1:2,1);
pH1=[artH(:,1),p];
p=H\[p;1];
p=p./repmat(p(3,:),3,1);
p=p(1:2,:);
p1=[art(:,1),p];
% Lout = twopts2L(artH(:,2));
p=artH(:,2)+10000*Lout(1:2,1);
pH2=[artH(:,2),p];
p=H\[p;1];
p=p./repmat(p(3,:),3,1);
p=p(1:2,:);
p2=[art(:,2),p];
artAllH=[pH1;pH2];
artAll=[p1;p2];
% figure,axis equal
% hold on
% plot(artAllH(1:2:end,1),artAllH(2:2:end,1),'-r');
% plot(artAllH(1,:),artAllH(2,:),'-b');
% plot(artAllH(3,:),artAllH(4,:),'-g');
% hold off
end
