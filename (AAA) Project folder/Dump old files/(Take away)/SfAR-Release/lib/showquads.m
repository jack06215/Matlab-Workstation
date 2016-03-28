function showquads(im,quads,numquads,LS,alpha)

if isempty(numquads)
    numquads=size(quads,2);
end

if length(numquads)~=size(quads,2)
    qseg=zeros(1,size(quads,2));
    for index=1:length(numquads)
        qseg((sum(numquads(1:index-1))+1):sum(numquads(1:index)))=index;
    end
else
    qseg=numquads;
end

regionhulls=cell(1,size(quads,2));
for index=1:length(regionhulls)
    regionhulls{index}=[reshape(quads(:,index),2,4),quads(1:2,index)];
end

if nargin>4
    visualizeregions2(im,regionhulls,LS,qseg,alpha);
else
    visualizeregions2(im,regionhulls,LS,qseg);
end