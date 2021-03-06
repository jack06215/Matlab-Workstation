refImg = imread('Garfield_Building_Detroit.jpg');
num_vertStrip = 2;
num_horzStrip = 1;
num_chn = 3;

col_cut = repmat(size(refImg,2)/num_vertStrip,[1 num_vertStrip]);
row_cut = repmat(size(refImg,1)/num_horzStrip,[1 num_horzStrip]);
stripRefImg = mat2cell(refImg, row_cut, col_cut, num_chn);
stripGray = cell(size(row_cut,2), size(col_cut,2));

done = false;
plot_row = 1;
plot_col = 1;
plot_index = 1;

while(not(done))
%     disp(['[', num2str(plot_row), ', ', num2str(plot_col), ']']);
    stripGray{plot_row, plot_col} = stripRefImg{plot_row,plot_col};
    subplot(size(stripRefImg, 1), size(stripRefImg, 2), plot_index);
    imshow(stripGray{plot_row,plot_col});
%     imwrite(stripGray{plot_row,plot_col}, ['BV', num2str(plot_index), '.png']);
    plot_col = plot_col + 1;
    if (plot_col > size(stripRefImg,2))
        plot_row = plot_row + 1;
        plot_col = 1;
        if (plot_row > size(stripRefImg,1))
            done = true;
        end
    end
    plot_index = plot_index + 1;
end
% figure;
% refImg_modify = cell2mat(stripGray);
% imshow(refImg_modify);