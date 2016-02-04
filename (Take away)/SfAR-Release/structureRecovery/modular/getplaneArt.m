function planeArt = getplaneArt(segAdj,artSeg,PArt_im_c,center)

planeArt=cell(1,size(segAdj,2));
for i=1:size(planeArt,2)
    planeArt{1,i}=zeros(4,0);
end
[row,col] = find(triu(segAdj));
for i=1:size(row,1)
    p1=row(i);
    p2=col(i);
    art1=PArt_im_c(:,artSeg(p1,:)>0 & artSeg(p2,:)>0);
    art1=art1+repmat(center,1,size(art1,2));
    temp=[art1(:,1);art1(:,2)];
    planeArt{1,p1}=[planeArt{1,p1} temp];
    planeArt{1,p2}=[planeArt{1,p2} temp];
end
