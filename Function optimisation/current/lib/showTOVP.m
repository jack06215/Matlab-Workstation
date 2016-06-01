function [] = showTOVP( g, f, vanishing)%, point, foc )
figure,
imshow(g)
hold on;
% ri = randperm(size(point,1));
% if length(ri) > 2000
%     ri = ri(1:2000);
% end
% for j = 1:length(ri)
%     i = ri(j);
%     if norm(point(i,:)) < Inf & norm(point(i,:)) > norm(size(f)) / 2
%         plot(point(i,1)+size(f,2)/2,point(i,2)+size(f,1)/2,'x','color','b');
%     end
% end

color = hsv(3);

lt = min(vanishing(:,1)) + size(f,2)/2 - 300;
rt = max(vanishing(:,1)) + size(f,2)/2 + 300;
tp = min(vanishing(:,2)) + size(f,1)/2 - 300;
bm = max(vanishing(:,2)) + size(f,1)/2 + 300;
axis([lt rt tp bm]);
plot([0 vanishing(1,1)] +size(f,2)/2,[0 vanishing(1,2)] + size(f,1)/2,'.-','markersize',10,'linewidth',2,'color','k');
plot([0 vanishing(2,1)] +size(f,2)/2,[0 vanishing(2,2)] + size(f,1)/2,'.-','markersize',10,'linewidth',2,'color','k');
plot([0 vanishing(3,1)] +size(f,2)/2,[0 vanishing(3,2)] + size(f,1)/2,'.-','markersize',10,'linewidth',2,'color','k');


plot(vanishing(1,1) +size(f,2)/2,vanishing(1,2) +size(f,1)/2,'*','color',color(1,:),'markersize',15,'linewidth',3);
plot(vanishing(2,1) +size(f,2)/2,vanishing(2,2) +size(f,1)/2,'*','color',color(2,:),'markersize',15,'linewidth',3);
plot(vanishing(3,1) +size(f,2)/2,vanishing(3,2) +size(f,1)/2,'*','color',color(3,:),'markersize',15,'linewidth',3);

fprintf('Coordinates of Detected Vanishing Points:\n');
fprintf('%f\t%f\n',vanishing(1,1) +size(f,2)/2,vanishing(1,2) +size(f,1)/2);
fprintf('%f\t%f\n',vanishing(2,1) +size(f,2)/2,vanishing(2,2) +size(f,1)/2);
fprintf('%f\t%f\n',vanishing(3,1) +size(f,2)/2,vanishing(3,2) +size(f,1)/2);
% fprintf('Estimated Focal Length: %d\n',foc);
hold off;
end
