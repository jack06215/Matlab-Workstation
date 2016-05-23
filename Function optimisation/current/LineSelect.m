addpath(genpath('.'));
ccc;
img = imread('data/018.jpg');

% Line Detection and Re-arrangement
img_ls = getLines(rgb2gray(img),40);
img_ls = img_ls(:,1:4)';
img_ls = [img_ls(1,:); img_ls(3,:); img_ls(2,:); img_ls(4,:)]; % [x1,y1,x2,y2]
fig1 = figure;%('KeyReleaseFcn', @Key_Down);
imshow(img), hold on;
colorCode = hsv(size(img_ls,2));
for i=1:size(img_ls,2)
    plot(img_ls([1,3],i), img_ls([2,4],i), 'Color', colorCode(i,:), 'LineWidth', 2);
    pause(0.1);
end
hold off;



