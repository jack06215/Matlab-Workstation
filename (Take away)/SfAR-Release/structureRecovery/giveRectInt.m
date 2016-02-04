function [ lines ] = giveRectInt( art,q1 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% q1=goodquads2(:,rsegs(pindex2,:));
lines=zeros(8,size(q1,2));
q1=[q1;q1(1:2,:)];
                    test1=q1(1:4,:);
                        test2=q1(3:6,:);
  
testV1=line2Vector(test1);
testV2=line2Vector(test2);
artV=line2Vector(art);
nukta1=artV'*testV1;
nukta2=artV'*testV2;
nukta1=sqrt(nukta1.^2);

nukta2=sqrt(nukta2.^2);
f=nukta1<=nukta2;
    ind1=find(f);
    ind2=find(~f);
    lines1=[art,q1(1:4,ind1)];
    lines11=[art,q1(5:8,ind1)];
    p=size(lines1,2)-1;
    p=[ones(1,p);2:1:p+1];
    int1=lsIntersect(p,lines1);
    int11=lsIntersect(p,lines11);
    lines2=[art,q1(3:6,ind2)];
    lines22=[art,q1(7:end,ind2)];
    p=size(lines2,2)-1;
    p=[ones(1,p);2:1:p+1];
    int2=lsIntersect(p,lines2);
    int22=lsIntersect(p,lines22);
    
    for i=1:size(int1,2)
        dist1 = pdist([int1(:,i)';q1(1:2,ind1(1,i))';q1(3:4,ind1(1,i))']);
        if dist1(1,1)<=dist1(1,2)
        temp1=[q1(3:4,ind1(1,i));int1(:,i)];
        else
            temp1=[q1(1:2,ind1(1,i));int1(:,i)];
        end
        
        dist1 = pdist([int11(:,i);q1(5:6,ind1(1,i));q1(7:8,ind1(1,i))]);
        if dist1(1,1)<=dist1(1,2)
        temp2=[q1(7:8,ind1(1,i));int11(:,i)];
        else
            temp2=[q1(5:6,ind1(1,i));int11(:,i)];
        end
        lines(:,ind1(1,i))=[temp1;temp2];
    end
    
    for i=1:size(int2,2)
        dist1 = pdist([int2(:,i)';q1(3:4,ind2(1,i))';q1(5:6,ind2(1,i))']);
        if dist1(1,1)<=dist1(1,2)
        temp1=[q1(5:6,ind2(1,i));int2(:,i)];
        else
            temp1=[q1(3:4,ind2(1,i));int2(:,i)];
        end
        
        dist1 = pdist([int22(:,i);q1(7:8,ind2(1,i));q1(1:2,ind2(1,i))]);
        if dist1(1,1)<=dist1(1,2)
        temp2=[q1(1:2,ind2(1,i));int22(:,i)];
        else
            temp2=[q1(7:8,ind2(1,i));int22(:,i)];
        end
        lines(:,ind2(1,i))=[temp1;temp2];
    end


%        q1(end-1:end,:)=q1(1:2,:);
% hFig = [hFig, az_fig];
%                     imagesc(im),axis equal;
%                     
%                     test1=[q1(1:4,:)];
%                         test2=[q1(3:6,:)];
%                     
%                     showLS(test1,[0,1,0]);
%                     
%                     showLS(test2,[0,1,0]);
%                     showLS(q1(5:8,:),[0,1,0]);
%                     
%                     showLS(q1(7:end,:),[0,1,0]);
%                     showLS(art,[0,1,0]);
                    
                    

end

