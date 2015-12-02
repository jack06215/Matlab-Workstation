f = imread('Sample Images\fig1.jpg');
g = f;
f = rgb2gray(f);
%line = getLines(f,5);
figure(1);
imshow(g), hold on;
i = 339;
%for i = 49:100%1:size(line, 1);
    plot(line(i, [1 2])', line(i, [3 4])', 'Color', 'Red', 'LineWidth', 2);
    plot(line(i,1),line(i,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
    plot(line(i,2),line(i,4),'x', 'Color', 'Green', 'LineWidth', 2);
    pause(.05);
%end
%[point, vanishing, foc] = detectVanishingPoint(g, f, line);