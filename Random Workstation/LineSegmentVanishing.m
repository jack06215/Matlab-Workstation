f = imread('Sample Images\object0079.view04.png');
g = f;
f = rgb2gray(f);
line = getLines(f,50);
figure(1);
imshow(g), hold on;
k = 0;
i = 40;
% for j = 1:size(line, 1);
%     j_deg = rad2deg(line(j,5));
%     
%     if (j_deg >= 0)
%         k = k+1;
%         if (j_deg <= 30)
%             k = k+1;
%             % Vertical
%             plot(line(j, [1 2])', line(j, [3 4])', 'Color', 'g', 'LineWidth', 2);
%         end
%         if (j_deg >=45 && j_deg <= 90)
%             k = k+1;
%             % Horizontal
%             plot(line(j, [1 2])', line(j, [3 4])', 'Color', 'y', 'LineWidth', 2);
%         end
%     else % if j_deg < 0
%         if (j_deg >= -30)
%             k = k+1;
%             % Vertical
%             plot(line(j, [1 2])', line(j, [3 4])', 'Color', 'g', 'LineWidth', 2);
%         else
%             k = k+1;
%             if (j_deg >= -90)
%                 k = k+1;
%                 plot(line(j, [1 2])', line(j, [3 4])', 'Color', 'm', 'LineWidth', 2);
%             else
%                 k = k+1;
%                 j_deg = j_deg + 180;
%                 if (j_deg >= -120)
%                     k = k+1;
%                     % Horizontal
%                     plot(line(j, [1 2])', line(j, [3 4])', 'Color', 'm', 'LineWidth', 2);
%                 end
%             end
%         end
%     end
% end
for i = 1:size(line,1)
     %plot(line(i, [1 2])', line(i, [3 4])', 'Color', 'Red', 'LineWidth', 2);
     plot(line(i,1),line(i,3),'x', 'Color', 'Yellow', 'LineWidth', 2);
     plot(line(i,2),line(i,4),'x', 'Color', 'Green', 'LineWidth', 2);
     %pause(0.01);
     k = k+1;
end
[point, vanishing, foc] = detectVanishingPoint(g, f, line);