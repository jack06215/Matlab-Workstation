function [fig Store] = getTextureMapping(planes,im,H,pts,center,xp)

%Texture maps the structure computed by computeStructure
%
%   For each segment, the fronto parallel view of that part of the image is
%   computed and texture mapped on a surface with appropriate plane normal,
%   distance and boundaries.
%
%   Inputs:
%       planes      -   Plane matrix, where each column is the plane normal
%       im          -   image matrix in [(X,Y,3)]uint8 format
%       H           -   Plane homograpies placed in cell structure
%       pts         -   pts for each segment,placed in cell structure
%       xp          -   non-liner optimization output
%       center      -   image center
%
%   Outputs:
%       X           -   figure handle for the 3D structure
%       Store       -   X,Y,Z,fronto-parallel images for each segment
%                       stored in cell structure
%
%Written on 3rd December, 2012 in SfAR revision.


Store=cell(5,size(planes,2));
fig=figure;
for i=1:size(planes,2)
    
    [imNew,xcurr,bound,a]=getfacetexture(im,H{1,i},[pts{1,i};ones(1,size(pts{1,i},2))],0);

    bound=bound(1:2,:);
    bound=bound-repmat(center,1,size(bound,2));
    p3=get3DPts(bound,planes,xp,i);
    x=p3(1,:);
    X= [x(1) x(2);x(4) x(3)];
    x=p3(2,:);
    Y= -1*[x(1) x(2);x(4) x(3)];
    x=p3(3,:);
    Z= -1*[x(1) x(2);x(4) x(3)];

    h=surface(X,Y,Z,'FaceColor','r');
    set(h,'CData',imNew,'FaceColor','texturemap');
    set(h,'edgecolor','none','facealpha','texture','alphadata',a);
    Store{1,i}=X;
    Store{2,i}=Y;
    Store{3,i}=Z;
    Store{4,i}=imNew;
    Store{5,i}=a;
end
axis equal