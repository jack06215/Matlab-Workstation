function [ cost ] = artOrthSVR(xp,L_im,seg,inliers,PArt_im_c,artSeg,PAdj  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

cost=0;
K=diag([xp(1),xp(1),1]);
for i=1:size(seg,1)
    currinliers=inliers{i};
    x0=xp(2*i:2*i+1);
    Lcurr=L_im(:,seg(i,:)>0);
    cost=cost+orthocost_HR(x0,Lcurr,K,currinliers);
end

cost=cost+artCostSVR(xp,PArt_im_c, artSeg, PAdj, 0);
% 
% (@artCostSVR,xp,options,PArt_im_c, artSeg, PAdj, 0);
% rectifyOrthoR(Lcurr,K,currinliers,x0,1);
% orthocost_HR,x0,options,L,K,A);
% Lcurr=L_im(:,seg(index1,:)>0);
%         Acurr=LAdj(seg(index1,:)>0,seg(index1,:)>0);
%         [H1,currinliers,x0]=ransacfitH(Lcurr,K,Acurr,10^-3,1,2,0);
%         currinliers=zeros(size(Lcurr),2)<1;
%         x0=[0;0];
%         [H2,temp]=rectifyOrthoR(Lcurr,K,currinliers,x0,1);
end

