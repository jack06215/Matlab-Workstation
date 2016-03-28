function visualizeregions2(im,regionhulls,LS,rseg,alpha)

if nargin<5 || isempty(alpha)
    alpha=0.6*ones(1,length(regionhulls));
elseif length(alpha)~=length(regionhulls)
    alpha=alpha(1)*ones(1,length(regionhulls));
end
% visualize regions
% az_fig;
imagesc(im);
cmap=[0,0,0;...
    1,0,0;...
    0,1,0;...
    0,0,1;...
    1,1,0;...
    1,0,1;...
    0,1,1;...
    1,1,1];
hold on;
for rindex=1:length(regionhulls)
    color=cmap(rem(rseg(rindex),size(cmap,1))+1,:);
    patch(regionhulls{rindex}(1,:),regionhulls{rindex}(2,:),color,'FaceAlpha',alpha(rindex));
end
axis equal; colormap gray;
if nargin>2
    showLS(LS,[1,1,1],1);
end
