function [ hFig ] = visualize_art_line( hFig,im,LS_P1,LS_P2,LS_Hull,bestInd,pindex1,pindex2,artlineinds,talk )
%Visualises articulation line between 2 planes
%
%   Inputs:
%       hFig        -   The array containing all figures
%       im          -   original image
%       LS_P1       -   Line segments of endpoints of quads of plane 1
%       LS_P2       -   Line segments of endpoints of quads of plane 2
%       LS_Hull     -   LS line segments with convex hull of all regions appended.
%       bestInd     -   The index of the articulation line between the two
%                       planes.
%       pindex1     -   index of first plane in the pair
%       pindex2     -   index of second plane in the pair
%       artlineinds -   The matrix that contains best articulation line
%                       index in the format artlineinds(plane1,plane2)
%       talk        -   TALK
%
%Written on 13th Sept, 2012 in SfAR revision.

if artlineinds(pindex1,pindex2) && talk
    
    hFig = [hFig, az_fig];
    imagesc(im),axis equal;
    showLS(LS_P1,[1,0,0]);showLS(LS_P2,[0,1,0]);
    hold on;
    plot(LS_Hull([1,3],bestInd),LS_Hull([2,4],bestInd),'m-','linewidth',3);
    hold off;
    title(['After computing the articulation b/w plane group # ',num2str(pindex1),' and # ',num2str(pindex2)]);
    set(hFig(1,end),'Name',['plane',num2str(pindex1),'And',num2str(pindex2)]);
end

end

