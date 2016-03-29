function [newLS,inds]=sortLS(LS)
% sort line segments by descending length

lslens=sum((LS(1:2,:)-LS(3:4,:)).^2);
[dummy,inds]=sort(lslens,2,'descend');
newLS=LS(:,inds);