function [inpercent] = getRectanglesHypothesisScore(L,Ladj,quads,numquads,quads_c,inliers,numhyp)
%GETQUADRANGLESHYPOTHESISSCORE

% inputs
% L: line segments in vector format
% Ladj: adjacency matrix for line segments
% quads: the end points of the quads detected
% numquads: number of quads per plane hypothesis
% quads_c: quads shifted to the center
% inliers:
% numhyp: number of plane hypothesis
% outputs
% inpercent: the score assigned to each quad

qvotes=zeros(numhyp,size(quads,2));
for hindex=1:numhyp
    currinliers=Ladj.*inliers{hindex};
    [ind1,ind2]=find(currinliers>0);
    intpts=zeros(2,length(ind1));
    
    for lindex=1:length(ind1)
        intpt=az_hcross(L(:,ind1(lindex)),L(:,ind2(lindex))); intpt=intpt(1:2);
        intpts(:,lindex)=intpt;
    end
    for qindex=1:size(quads,2)
        currvotes = inpolygon(intpts(1,:),intpts(2,:),...
            quads_c([1:2:end,1],qindex),quads_c([2:2:end,2],qindex));
        qvotes(hindex,qindex)=sum(currvotes);
    end
    
end
goodqvotes=zeros(1,size(qvotes,2));
for hindex=1:numhyp
    goodqvotes((sum(numquads(1:hindex-1))+1):sum(numquads(1:hindex)))=...
        qvotes(hindex,(sum(numquads(1:hindex-1))+1):sum(numquads(1:hindex)));
end
inpercent=goodqvotes./(sum(qvotes)+eps);

end

