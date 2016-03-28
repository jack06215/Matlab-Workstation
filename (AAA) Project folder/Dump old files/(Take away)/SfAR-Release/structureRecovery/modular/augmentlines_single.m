function [lines,currInlier]=augmentlines_single(goodinds_cur,LS_c)

LSpair1=LS_c(:,goodinds_cur(1,:));
LSpair2=LS_c(:,goodinds_cur(2,:));
LSn=[LSpair1,LSpair2];                                                      %lineNos that constitute cur seg
mid=size(LSpair1,2);

[lines,~,indLines2LSn]=unique(LSn','rows');
lines=lines';
indLines2LSn1=indLines2LSn(1:mid);
indLines2LSn2=indLines2LSn(mid+1:end);
currInlier=zeros(size(lines,2));                                        %components of rects. (which line pairs intersect to form rects)
for k=1:mid
    currInlier(indLines2LSn1(k),indLines2LSn2(k))=1;
    currInlier(indLines2LSn2(k),indLines2LSn1(k))=1;
end
