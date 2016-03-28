clear, close all;
refFrm = imread('..\(Sample Images)\outImg.png');
frm_line = getLines(rgb2gray(refFrm), 40);

figure;
imshow(refFrm), hold on;
title('Current');

row_del_index = false(size(frm_line,1),1);
for i=1:size(frm_line,1)
    if (frm_line(i,3) <= size(refFrm, 2) / 2)
        if (frm_line(i,4) <= size(refFrm, 2) / 2) 
            row_del_index(i) = true;
        end
    end
end

frm_line(row_del_index,:) = [];
plot(frm_line(:,3),frm_line(:,1),'o', 'Color', 'Red', 'LineWidth', 2);
plot(frm_line(:,4),frm_line(:,2),'o', 'Color', 'Red', 'LineWidth', 2);