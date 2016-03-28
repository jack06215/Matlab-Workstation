function [im2,xp,bound,a]=getfacetexture(im1,H,x,numpadding)

% select the points on the current plane and warp them according to the
% image

xcurr=H*x;
xcurr=xcurr./repmat(xcurr(3,:),3,1);

% log=poly2mask(x(1,:),x(2,:),size(im1,1),size(im1,2));
% a=+log;
% log=~log;
% log=+log;
% log=cat(3,-255*log,255*log,-255*log);
% im1=double(im1)+log;
% im1=uint8(im1);
xmin=floor(min(xcurr(1,:))); 
xmax=ceil(max(xcurr(1,:)));
ymin=floor(min(xcurr(2,:)));
ymax=ceil(max(xcurr(2,:)));

[im2,xdata,ydata]=imtransform(im1,maketform('projective',H'), ...
    'XData',[xmin xmax],'YData',[ymin ymax] ,'FillValues',[255;255;255]);



diff=sqrt((size(im2,1)-(ymax-ymin))^2);
diff1=sqrt((size(im2,2)-(xmax-xmin))^2);
if max([diff; diff1])>10
im2 = imresize(im2, [ymax-ymin xmax-xmin]);
end
 
%
% 
% plot([0 xmax-xmin],[0 ymax-ymin] ,'-b','LineWidth',2);

xp=xcurr -repmat([xmin;ymin;0],1,size(xcurr,2));

% figure
% imshow(im2);
% hold on
% plot(xp(1,:),xp(2,:),'-r','LineWidth',2);

bound=[0 size(im2,2) size(im2,2) 0;0 0 size(im2,1) size(im2,1)];
bound=bound+repmat([xmin;ymin],1,size(bound,2));
bound=[bound;ones(1,size(bound,2))];
bound=H\bound;
bound=bound./repmat(bound(3,:),3,1);
log=poly2mask(xp(1,:),xp(2,:),size(im2,1),size(im2,2));
a=+log;
% log=~log;
% log=+log;
% log=cat(3,-255*log,255*log,-255*log);
% im2=double(im2)+log;
% im2=uint8(im2);




