refImg = imread('Sample Images\fig1.jpg');
refImg_BW = rgb2gray(refImg);
num_vertStrip = 5;
num_horzStrip = 5;
num_dim = 3;

col_cut = repmat(size(refImg,2)/num_vertStrip,[1 num_vertStrip]);
row_cut = repmat(size(refImg,1)/num_horzStrip,[1 num_horzStrip]);
stripImg = mat2cell(refImg, row_cut, col_cut, num_dim);

done = false;
plot_row = 1;
plot_col = 1;
plot_index = 1;

while(not(done))
    disp(['[', num2str(plot_row), ', ', num2str(plot_col), ']']);
    subplot(size(stripImg, 1), size(stripImg, 2), plot_index);
    imshow(stripImg{plot_row,plot_col});
    plot_col = plot_col + 1;
    if (plot_col > size(stripImg,2))
        plot_row = plot_row + 1;
        plot_col = 1;
        if (plot_row > size(stripImg,1))
            done = true;
        end
    end
    plot_index = plot_index + 1;
end