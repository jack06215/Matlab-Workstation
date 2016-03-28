function planes = findOptimizedPlanesVector(xp,no_of_segs)

planes=zeros(3,no_of_segs);
for index1=1:no_of_segs
    ax=xp(2*index1);ay=xp(2*index1+1);
    Rtemp=makehgtform('xrotate',ax,'yrotate',ay); Rtemp=Rtemp(1:3,1:3);
    planes(:,index1)=Rtemp'*[0;0;1];
end