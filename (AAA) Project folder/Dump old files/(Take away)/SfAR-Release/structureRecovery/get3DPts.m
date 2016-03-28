
function [cPts3d]=get3DPts(cPts,planes,xp,planeNo)
    cPts=[cPts; ones(1,size(cPts,2))];

    Kp=diag([xp(1),xp(1),1]);

    Kinv=pinv(Kp);
    p=planes(:,planeNo);
    cPts3d=zeros(3,size(cPts,2));
    for index=1:size(cPts,2)
        X=Kinv*cPts(:,index);
        d=p(4,1);
        v=p(1:3,1);
        lamb = d/(v'*X);
        cPts3d(:,index)=lamb*X;
    end

end
