function [artSeg,PAdj,art] = getartSeg(r,c,v,unique_segs,LS_Hull_c)

art=zeros(2,2*size(r,1));
artSeg=zeros(size(unique_segs,1),2*size(r,1));
segAdj=zeros(size(unique_segs,1));                 
for i=1:size(r,1)
    art(:,2*i-1)=LS_Hull_c(1:2,v(i));               %points of artline in 2i, 2i-1 th columns
    art(:,2*i)=LS_Hull_c(3:4,v(i));
    j1=find(unique_segs==r(i));                     %new index ith row, in unique_segs 
    artSeg(j1,2*i)=1;                               %row=seg# in unique_seg array; col= art line # (2i, 2i-1) th value
    artSeg(j1,2*i-1)=1;
    j2=find(unique_segs==c(i));
    artSeg(j2,2*i-1)=1;
    artSeg(j2,2*i)=1;
    PAdj(j1,j2)=1;
    PAdj(j2,j1)=1;
end