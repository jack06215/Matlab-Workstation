close all;
refImg = imread('DSC_0764.JPG');
curImg = imread('DSC_0765.JPG');
%% Construct image strips
num_vertStrip = 4;
num_horzStrip = 1;
num_dim = 3;

col_cut = repmat(size(curImg,2)/num_vertStrip,[1 num_vertStrip]);
row_cut = repmat(size(curImg,1)/num_horzStrip,[1 num_horzStrip]);
stripCurImg = mat2cell(curImg, row_cut, col_cut, num_dim);
stripCurImg_copy = cell(size(row_cut,2), size(col_cut,2));

done = false;
plot_row = 1;
plot_col = 1;
plot_index = 1;
while(not(done))
%     disp(['[', num2str(plot_row), ', ', num2str(plot_col), ']']);
    stripCurImg_copy{plot_row, plot_col} = stripCurImg{plot_row,plot_col};
    %figure;
    %imshow(stripCurImg_copy{plot_row,plot_col});
    plot_col = plot_col + 1;
    if (plot_col > size(stripCurImg,2))
        plot_row = plot_row + 1;
        plot_col = 1;
        if (plot_row > size(stripCurImg,1))
            done = true;
        end
    end
    plot_index = plot_index + 1;
end

%% Estimate geometric transform

difference = 100;

point_i = [0,0;
           0, size(curImg, 1);
           size(curImg, 2), 0;
           size(curImg, 2), size(curImg, 1)];
point_iPrime = [0,0;
                0, size(curImg, 1);
                size(curImg, 2) - difference, 0 + difference;
                size(curImg, 2) - difference, size(curImg, 1) - difference];
            
tform = estimateGeometricTransform(point_i, point_iPrime, 'projective');

curImg = imwarp(curImg, tform);



figure, imshow(refImg), hold on;
title(['dim: ', num2str(size(refImg, 1)), ' x ', num2str(size(refImg, 2))]);
[PtRefX,PtRefY] = getpts;
groundRef_X1Y1 = [PtRefX(1), PtRefY(1), 0];
groundRef_X2Y2 = [PtRefX(2), PtRefY(2), 0];
plot(groundRef_X1Y1(1),groundRef_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
plot(groundRef_X2Y2(1),groundRef_X2Y2(2),'o','Color','Yellow', 'LineWidth', 3);
line(PtRefX,PtRefY, 'Color', 'Blue', 'LineWidth', 3);


figure, imshow(curImg);
title(['dim: ', num2str(size(curImg, 1)), ' x ', num2str(size(curImg, 2))]);
%% Zero-fill the image if their dimension are not equal
iwidth = max(size(refImg, 2), size(curImg, 2));
if (size(refImg, 2) < iwidth)
    refImg(1,iwidth, 1) = 0;
end
if (size(curImg, 2) < iwidth)
    curImg(1, iwidth, 1) = 0;
end

iheight = max(size(refImg, 1), size(curImg, 1));
if (size(refImg, 1) < iheight)
    refImg(iheight, end, 1) = 0;
end
if (size(curImg, 1) < iheight)
    curImg(iheight, end, 1) = 0;
end
newImg = cat(2, refImg, curImg);

figure, imshow(newImg);
title(['dim: ', num2str(size(newImg, 1)), ' x ', num2str(size(newImg, 2))]);