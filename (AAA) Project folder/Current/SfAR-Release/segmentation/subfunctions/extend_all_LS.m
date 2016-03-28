function newLS=extend_all_LS(LS,imsize,talk)
if nargin<3
    talk=0;
end
BB=[1;1;imsize(1);imsize(2)]+[-1;-1;1;1];
dthresh=inf;
newLS=zeros(size(LS));
for index=1:size(LS,2)
    [newls,BB]=extend_ls(LS,index,BB,talk,dthresh);
    newLS(:,index)=newls;
end