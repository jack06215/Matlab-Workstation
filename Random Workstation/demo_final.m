f = imread('Sample Images\object0079.view04.png');
g = f;
f = rgb2gray(f);
line = getLines(f,50);
figure(1);
imshow(g), hold on;
for i = 1:size(line,1)
     %plot(line(i, [1 2])', line(i, [3 4])', 'Color', 'Red', 'LineWidth', 2);
     plot(line(i,1),line(i,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
     plot(line(i,2),line(i,4),'x', 'Color', 'Green', 'LineWidth', 2);
     %pause(0.01);
end
[vanishing, point, foc] = detectVanishingPoint(g, f, line);

if true
    figure,
    imshow(g)
    hold on;
    ri = randperm(size(point,1));
    if length(ri) > 2000
        ri = ri(1:2000);
    end
    for j = 1:length(ri)
        i = ri(j);
        if norm(point(i,:)) < Inf & norm(point(i,:)) > norm(size(f)) / 2
            plot(point(i,1)+size(f,2)/2,point(i,2)+size(f,1)/2,'x','color','b');
        end
    end
    lt = min(vanishing(:,1)) + size(f,2)/2 - 300;
    rt = max(vanishing(:,1)) + size(f,2)/2 + 300;
    tp = min(vanishing(:,2)) + size(f,1)/2 - 300;
    bm = max(vanishing(:,2)) + size(f,1)/2 + 300;
    axis([lt rt tp bm]);
    plot([0 vanishing(1,1)] +size(f,2)/2,[0 vanishing(1,2)] + size(f,1)/2,'.-','markersize',10,'linewidth',2,'color','k');
    plot([0 vanishing(2,1)] +size(f,2)/2,[0 vanishing(2,2)] + size(f,1)/2,'.-','markersize',10,'linewidth',2,'color','k');
    plot([0 vanishing(3,1)] +size(f,2)/2,[0 vanishing(3,2)] + size(f,1)/2,'.-','markersize',10,'linewidth',2,'color','k');
    plot(vanishing(1,1) +size(f,2)/2,vanishing(1,2) +size(f,1)/2,'s','color','k','markersize',15,'linewidth',2);
    plot(vanishing(2,1) +size(f,2)/2,vanishing(2,2) +size(f,1)/2,'s','color','k','markersize',15,'linewidth',2);
    plot(vanishing(3,1) +size(f,2)/2,vanishing(3,2) +size(f,1)/2,'s','color','k','markersize',15,'linewidth',2);
end
fprintf('Coordinates of Detected Vanishing Points:\n');
fprintf('%f\t%f\n',vanishing(1,1) +size(f,2)/2,vanishing(1,2) +size(f,1)/2);
fprintf('%f\t%f\n',vanishing(2,1) +size(f,2)/2,vanishing(2,2) +size(f,1)/2);
fprintf('%f\t%f\n',vanishing(3,1) +size(f,2)/2,vanishing(3,2) +size(f,1)/2);
fprintf('Estimated Focal Length: %d\n',foc);