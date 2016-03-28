function [quads]=getquads(LS_c,L,H,singleflag)

    if nargin<4
        singleflag=0;
    end
    
    if size(LS_c,2) < 2
        error('Line segment must in pair');
    elseif size(LS_c, 2) > 3
        error('Not implemented yet');
    end
    
    if size(LS_c,2) ~= size(L,2)
        error('Line segment & vector matrix not matched');
    end
    %for index=1:length(ind1)
        ls1=LS_c(:,1);
        ls2=LS_c(:,2);
        lv1=L(:,1);
        lv2=L(:,2);
        [intpt,intflag1,intflag2]=testintoverlap(lv1,lv2,ls1,ls2);
%         intflag1
%         intflag2
        % construct corresponding quadrangles
        quads=getquadsfromint(ls1,ls2,intpt,intflag1,intflag2,H,singleflag);
    %end
end

function [intpt,intflag1,intflag2]=testintoverlap(lv1,lv2,ls1,ls2)
    intpt=az_hcross(lv1,lv2); intpt=intpt(1:2);
    intflag1=ptinls(intpt,ls1);
    intflag2=ptinls(intpt,ls2);
end

function fulloverlapflag=ptinls(pt1,ls2)
    fulloverlapflag=inpolygon(pt1(1),pt1(2),ls2([1,3]),ls2([2,4]));
end


function currquads=getquadsfromint(ls1,ls2,intpt,intflag1,intflag2,H,singleflag)
    currquads=[];
    % take everything into rectified space
    pts=[[ls1(1:2),ls1(3:4),ls2(1:2),ls2(3:4),intpt];[1,1,1,1,1]];
    ptsp=H*pts; ptsp=ptsp(1:2,:)./[ptsp(3,:);ptsp(3,:)];
    ls1p=[ptsp(:,1);ptsp(:,2)];
    ls2p=[ptsp(:,3);ptsp(:,4)];
    intptp=ptsp(:,5);
%     intptp
    % test for the kind of overlap
    if intflag1 && intflag2    % if intersection lies on both segments
        % form corresponding four rectangle points in rectified space
        disp('Intersect on both');
        pt11p=ls2p(1:2)+(ls1p(1:2)-intptp);
        pt11=inv(H)*[pt11p;1]; pt11=pt11(1:2)/pt11(3);
        pt21p=ls2p(1:2)+(ls1p(3:4)-intptp);
        pt21=inv(H)*[pt21p;1]; pt21=pt21(1:2)/pt21(3);
        pt12p=ls2p(3:4)+(ls1p(1:2)-intptp);
        pt12=inv(H)*[pt12p;1]; pt12=pt12(1:2)/pt12(3);
        pt22p=ls2p(3:4)+(ls1p(3:4)-intptp);
        pt22=inv(H)*[pt22p;1]; pt22=pt22(1:2)/pt22(3);
        
        % form the quadrangles in original space
        currquads=[ [intpt; ls1(1:2); pt11; ls2(1:2)],...
                    [intpt; ls1(3:4); pt21; ls2(1:2)],...
                    [intpt; ls1(1:2); pt12; ls2(3:4)],...
                    [intpt; ls1(3:4); pt22; ls2(3:4)]];
        
    elseif intflag1 && singleflag    % if intersection lies on first segment only
        % pick the furthest point of the non-overlapping line segment
        disp('Intersect only first');
        dist1=norm(ls2p(1:2)-intptp); dist2=norm(ls2p(3:4)-intptp);
        if dist1>dist2
            farptp=ls2p(1:2);
            farpt=ls2(1:2);
        else
            farptp=ls2p(3:4);
            farpt=ls2(3:4);
        end
        % form corresponding two rectangle points in rectified space
        pt1p=farptp+(ls1p(1:2)-intptp);
        pt1=inv(H)*[pt1p;1]; pt1=pt1(1:2)/pt1(3);
        pt2p=farptp+(ls1p(3:4)-intptp);
        pt2=inv(H)*[pt2p;1]; pt2=pt2(1:2)/pt2(3);
        % form the quadrangles in original space
        currquads=[ [intpt; ls1(1:2); pt1; farpt],...
                    [intpt; ls1(3:4); pt2; farpt]];

    elseif intflag2 && singleflag    % if intersection lies on SECOND segment only
        % pick the furthest point of the non-overlapping line segment
        disp('Intersect only second');
        dist1=norm(ls1p(1:2)-intptp); dist2=norm(ls1p(3:4)-intptp);
        if dist1>dist2
            farptp=ls1p(1:2);
            farpt=ls1(1:2);
        else
            farptp=ls1p(3:4);
            farpt=ls1(3:4);
        end
        % form corresponding two rectangle points in rectified space
        pt1p=farptp+(ls2p(1:2)-intptp);
        pt1=inv(H)*[pt1p;1]; pt1=pt1(1:2)/pt1(3);
        pt2p=farptp+(ls2p(3:4)-intptp);
        pt2=inv(H)*[pt2p;1]; pt2=pt2(1:2)/pt2(3);
        % form the quadrangles in original space
        currquads=[ [intpt; ls2(1:2); pt1; farpt],...
                    [intpt; ls2(3:4); pt2; farpt]];

    end
end