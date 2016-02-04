function qadj=findOverlapWithSAP(quads)

% inputs
% quads: the end points of the quads detected
% outputs
% qadj: the adjacency matrix for quads

qadj=zeros(size(quads,2));
quads  = shrinkQuads( quads );
axes=getAxes(quads);
dots=projectToAxes(axes,quads);
for qindex=1:size(quads,2)
    overlap=determineOverlap( dots,qindex);
    qadj(qindex,:)=overlap;
    if ~rem(qindex,50)
        fprintf(1,'rectangle#%d\n',qindex);
    end
end

qadj=triu((qadj+qadj')>0,1);

end

function [ quads ] = shrinkQuads( quads )

diag1=quads(7:8,:)-quads(3:4,:);
diag2=quads(5:6,:)-quads(1:2,:);
diag1=diag1./repmat(sqrt(sum(diag1.^2)),2,1);
diag2=diag2./repmat(sqrt(sum(diag2.^2)),2,1);
quads(3:4,:)=quads(3:4,:)+10000*eps*diag1;
quads(7:8,:)=quads(7:8,:)-10000*eps*diag1;
quads(1:2,:)=quads(1:2,:)+10000*eps*diag2;
quads(5:6,:)=quads(5:6,:)-10000*eps*diag2;

end

function [ axes ] = getAxes( quads )

quads=[quads;quads(1:2,:)];
axes=zeros(8,size(quads,2));
for i=1:2:7
    a=quads(i+2:i+3,:)-quads(i:i+1,:);
    a=[-a(2,:);a(1,:)];
    a=a./repmat(sqrt(sum(a.^2)),2,1);
    axes(i:i+1,:)=a;
end

end

function [ dots ] = projectToAxes( ax,quads )

vertices=reshape(quads,2,size(quads,2)*4);
axes=reshape(ax,2,size(ax,2)*4);
axes=axes';
dots=axes*vertices;

end

function [ overlap ] = determineOverlap( dots,qindex)

overlap=zeros(1,size(dots,2)/4);
for i=1:size(dots,2)/4
    meDot=[dots(4*i-3:4*i,4*qindex-3:4*qindex);dots(4*qindex-3:4*qindex,4*qindex-3:4*qindex)];
    meDot=meDot';
    themDot=[dots(4*i-3:4*i,4*i-3:4*i);dots(4*qindex-3:4*qindex,4*i-3:4*i)];
    themDot=themDot';
    minMe=min(meDot);
    maxMe=max(meDot);
    minThem=min(themDot);
    maxThem=max(themDot);
    check= (minMe<minThem & minThem<maxMe) | (minThem<minMe & minMe<maxThem);
    overlap(1,i)=sum(+check)==size(check,2);
end



end



