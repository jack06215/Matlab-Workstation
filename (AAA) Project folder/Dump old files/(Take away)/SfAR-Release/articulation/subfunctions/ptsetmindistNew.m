function mindist=ptsetmindistNew(pts1,pts2)

dists=zeros(size(pts1,2),size(pts2,2));
for index1=1:size(pts1,2)
    for index2=1:size(pts2,2)
%         index1+
        dists(index1,index2)=p_poly_dist(pts2(1,index2), pts2(2,index2),...
            pts1(1,:), pts1(2,:)); 
%         sum((pts1(:,index1)-pts2(:,index2)).^2);
    end
end
% dists
% dists(:)

mindist=min(min(dists));