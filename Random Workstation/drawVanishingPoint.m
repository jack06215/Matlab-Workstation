function [] = drawVanishingPoint( refImg_original, refImg, refImg_vanishing, refImg_point, refImg_foc )
%UNTITLED Summary of this function goes here
if true
    figure,
    imshow(refImg_original)
    hold on;
    ri = randperm(size(refImg_point,1));
    if length(ri) > 2000
        ri = ri(1:2000);
    end
%     for j = 1:length(ri)
%         i = ri(j);
%         if norm(point(i,:)) < Inf & norm(point(i,:)) > norm(size(f)) / 2
%             plot(point(i,1)+size(f,2)/2,point(i,2)+size(f,1)/2,'x','color','b');
%         end
%     end
    lt = min(refImg_vanishing(:,1)) + size(refImg,2)/2 - 300;
    rt = max(refImg_vanishing(:,1)) + size(refImg,2)/2 + 300;
    tp = min(refImg_vanishing(:,2)) + size(refImg,1)/2 - 300;
    bm = max(refImg_vanishing(:,2)) + size(refImg,1)/2 + 300;
    axis([lt rt tp bm]);
    plot([0 refImg_vanishing(1,1)] +size(refImg,2)/2,[0 refImg_vanishing(1,2)] + size(refImg,1)/2,'.-','markersize',10,'linewidth',2,'color','k');
    plot([0 refImg_vanishing(2,1)] +size(refImg,2)/2,[0 refImg_vanishing(2,2)] + size(refImg,1)/2,'.-','markersize',10,'linewidth',2,'color','k');
    plot([0 refImg_vanishing(3,1)] +size(refImg,2)/2,[0 refImg_vanishing(3,2)] + size(refImg,1)/2,'.-','markersize',10,'linewidth',2,'color','k');
    plot(refImg_vanishing(1,1) +size(refImg,2)/2,refImg_vanishing(1,2) +size(refImg,1)/2,'s','color','k','markersize',15,'linewidth',2);
    plot(refImg_vanishing(2,1) +size(refImg,2)/2,refImg_vanishing(2,2) +size(refImg,1)/2,'s','color','k','markersize',15,'linewidth',2);
    plot(refImg_vanishing(3,1) +size(refImg,2)/2,refImg_vanishing(3,2) +size(refImg,1)/2,'s','color','k','markersize',15,'linewidth',2);
end
fprintf('Coordinates of Detected Vanishing Points:\n');
fprintf('%f\t%f\n',refImg_vanishing(1,1) +size(refImg,2)/2,refImg_vanishing(1,2) +size(refImg,1)/2);
fprintf('%f\t%f\n',refImg_vanishing(2,1) +size(refImg,2)/2,refImg_vanishing(2,2) +size(refImg,1)/2);
fprintf('%f\t%f\n',refImg_vanishing(3,1) +size(refImg,2)/2,refImg_vanishing(3,2) +size(refImg,1)/2);
fprintf('Estimated Focal Length: %d\n',refImg_foc);


end

