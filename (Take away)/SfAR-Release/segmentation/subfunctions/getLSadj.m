function [L1,L2,adj,hFig]=getLSadj(im,LSDscale,gapfillflag,extendflag,maxlines,athreshgap,dthreshgap,athreshadj,talk)
hFig=[];

if size(im,3)>1
    imgray=rgb2gray(im);
else
    imgray=im;
end

L = lsd(double(imgray'),LSDscale);
L=L(1:4,:);
if talk
    disp('filling gaps');
end

if gapfillflag
    L1=fillgaps3(L,athreshgap,dthreshgap);
else
    L1=L;
end
if talk
    hFig=[hFig az_fig];
    set(hFig(1,end),'Name','Original and Gap Filled Lines');
    imagesc(im), axis equal;
    showLS(L1);
    showLS(L(1:4,:),[0,1,0]);
    title('Original in green, Gap-filled in red');
    fprintf(1,'detected lines: %d, after gap-filling: %d\n',size(L,2),size(L1,2));
    if talk>2, pause, else pause(1), end
    disp('extending lines and finding adjacencies');
end

L1=sortLS(L1);
maxlines=min([maxlines,floor(0.7*size(L1,2))]);
L1=L1(:,1:maxlines);
% extend lines
if extendflag
    L2=extend_all_LS(L1,size(im));
else
    L2=L1;
end
% compute adjacencies
adj=findadj(L2,athreshadj);

if talk
    hFig=[hFig az_fig];
    set(hFig(1,end),'Name','Gap Filled and Extended Lines');
    imagesc(im), axis equal;
    showLS(L2);
    showLS(L1(1:4,:),[0,1,0]);
    title('Gap filled in green, Extended in red')
end
