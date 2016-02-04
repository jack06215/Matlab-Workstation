function [pts lines]=getPtsAndLines(planeArt,seg,L_im_2p_c,center,unique_segs,artLine,goodquads,rsegs)
img_boundX = [0 0 center(1) center(1)]*2;
img_boundY = [0 center(2) center(2) 0]*2;
lines=cell(1,size(planeArt,2));
pts=cell(1,size(seg,1));
for i=1:size(planeArt,2)
    L1=L_im_2p_c(:,seg(i,:)>0);
    L1=L1+repmat(center,2,size(L1,2));
    lines{1,i}=L1;
    pindex1=unique_segs(i,1);
    arts=planeArt{1,i};
    xf=[];
    yf=[];
    for j=1:size(arts,2)
        artCurr=arts(:,j);
        artOther=repmat(artCurr,1,size(artLine,2));
        [~,y]=find(artOther~=artLine);
        y=unique(y);
        artOther=artLine(:,y);
        [xcurr,ycurr]=extendRectangles(artCurr,artOther,goodquads,rsegs,...
            pindex1,1);
        [xcurr1,ycurr1]=extendRectangles(artCurr,artOther,goodquads,rsegs,...
            pindex1,2);
		[xcurr,ycurr]=polybool('&',xcurr,ycurr,img_boundX,img_boundY);
        [xcurr1,ycurr1]=polybool('&',xcurr1,ycurr1,img_boundX,img_boundY);
        [x,y]=polybool('+',xcurr,ycurr,xcurr1,ycurr1);
        [xf,yf]=polybool('+',x,y,xf,yf);
        [xf,yf]=removeHoles(xf',yf');
    end
    [xf,yf]=polybool('&',img_boundX,img_boundY,xf,yf);
    xf=xf(~isnan(xf));  yf=yf(~isnan(yf));
	pts{1,i}=[xf;yf];
end