function [H,x,fval]=fitHgivenLK(L1,L2,K,talk,x0)
% H is the homography
% x is the tuning parameter, in this case are the 2*1 representing angle
% rotation in x-axis and y-axis
% fval is the value of objective function
% fitting function to be used in ransac4

L=[L1,L2];
n1=size(L1,2);
Adj=zeros(2*n1);
for index=1:n1
    Adj(index,index+n1)=1;
    Adj(index+n1,index)=1;
end

if nargin<5
    x0=[0;0];
end
if nargin<4
    talk=1;
end

[H,x,fval]=rectifyOrthoR(L,K,Adj,x0,talk);
