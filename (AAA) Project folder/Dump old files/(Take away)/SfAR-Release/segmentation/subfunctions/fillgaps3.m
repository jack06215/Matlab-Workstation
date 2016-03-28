function LS=fillgaps3(LS,athresh,dthresh)

    if nargin<2 || isempty(athresh)
        athresh=2;   % degrees
    end
    if nargin<3 || isempty(dthresh)
        dthresh=1;   % dthresh times the length of the two segments
                     % will be allowed as gap to be filled
    end

    lindex1=0;
    while lindex1<size(LS,2)
        % pick the next line, divide the set into required parts
        lindex1=lindex1+1;
        currls=LS(:,lindex1);
        uncheckedLS=LS(:,lindex1+1:end);
        mergelist=zeros(1,size(uncheckedLS,2));
        % compare it to all unchecked lines to find line candidates to merge
        for lindex2=1:length(mergelist)
%             disp([lindex1,lindex2,size(LS,2)]);
            if limitedangle(LS(:,lindex1),uncheckedLS(:,lindex2),athresh)
                mergelist(lindex2)=1;
            end
        end
        if sum(mergelist)
%             display(mergelist);
            currLS=mergecloselinesegs([currls,uncheckedLS(:,mergelist>0)],athresh,dthresh);
%             uncheckedLS(:,~mergelist)
%             LS(:,lindex1:end)
            if sum(~mergelist)
                LS=[LS(:,1:lindex1-1),currLS,uncheckedLS(:,~mergelist)];
            else
                LS=[LS(:,1:lindex1-1),currLS];
            end
%             lindex1=lindex1+size(currLS,2)-1;
        end
    end
end
%% compute the angle, b/w all combintations of two ls
% terminates when any angle goes beyond athresh
function limitflag=limitedangle(ls1,ls2,athresh)    % degrees
    pts=[ls1(1:2),ls1(3:4),ls2(1:2),ls2(3:4)];
    combs=[1,2, 3,4;...
        
           1,2, 1,3;...
           1,2, 1,4;...
           1,2, 2,3;...
           1,2, 2,4;...
           
           3,4, 3,1;...
           3,4, 3,2;...
           3,4, 4,1;...
           3,4, 4,2;];
    limitflag=1;
    for index=1:size(combs,1)
        theta=lsangle([pts(:,combs(index,1));pts(:,combs(index,2))],...
            [pts(:,combs(index,3));pts(:,combs(index,4))]);
        if theta<(cosd(athresh))^2
            limitflag=0;
            break;
        end
    end
end
%% find angle b/w two line segments
function theta=lsangle(ls1,ls2)
    lv1=twopts2L(ls1);
    v1=lv1(1:2)/norm(lv1(1:2));
    lv2=twopts2L(ls2);
    v2=lv2(1:2)/norm(lv2(1:2));
%     theta=acosd(abs(v1'*v2));
    theta=(v1'*v2)^2;
end
%% merge multiple line segments into one
function ls=mergelinesegs(LS)
    pts=[LS(1:2,:),LS(3:4,:)];
    [minx,minxind]=min(pts(1,:));
    [maxx,maxxind]=max(pts(1,:));
    [miny,minyind]=min(pts(2,:));
    [maxy,maxyind]=max(pts(2,:));
    if maxx-minx>maxy-miny
        minind=minxind;
        maxind=maxxind;
    else
        minind=minyind;
        maxind=maxyind;
    end
    ls=[pts(:,minind);pts(:,maxind)];
end
%% compute close enough segments, merge them through the function above
function newLS=mergecloselinesegs(LS,athresh,dthresh)
%     LS
    dthreshsquared=dthresh^2;
    % sort the segments on the line, by their "left" endpoint
    maxx=max([LS(1,:),LS(3,:)]); minx=min([LS(1,:),LS(3,:)]);
    maxy=max([LS(2,:),LS(4,:)]); miny=min([LS(2,:),LS(4,:)]);
    if maxy-miny<maxx-minx
        longdim=1;
    else
        longdim=2;
    end
    LS=sortLSendpoints(LS,longdim);
    [dummy,inds]=sort(LS(longdim,:));
    LS=LS(:,inds);
    % merge close enough line segments
    newLS=zeros(4,size(LS,2));
    newLS(:,1)=LS(:,1);
    newlindex=1;
    LSlensquared=sum((LS(3:4,:)-LS(1:2,:)).^2);
    for lindex=2:size(LS,2)
        mergeflag=0;
        % check for limited angle
        if limitedangle(LS(:,lindex-1),LS(:,lindex),athresh)
            % check for overlap
            if newLS(longdim+2,newlindex)>=LS(longdim,lindex)
                mergeflag=1;
                % else check for closeness
            elseif sum((LS(3:4,lindex-1)-LS(1:2,lindex)).^2)<=...
                        dthreshsquared*(LSlensquared(lindex-1)+LSlensquared(lindex))
                    mergeflag=1;
            end
        end
        % merge if close enough
        if mergeflag
            newLS(:,newlindex)=mergelinesegs([newLS(:,newlindex),LS(:,lindex)]);
        else
            newlindex=newlindex+1;
            newLS(:,newlindex)=LS(:,lindex);
        end
    end
    newLS=newLS(:,1:newlindex);
end
%% sort the endpoints of line segments
function LS=sortLSendpoints(LS,dim)
    for index=1:size(LS,2)
        if LS(dim+2,index)<LS(dim,index)
            LS(:,index)=LS([3,4,1,2],index);
        end
    end
end
