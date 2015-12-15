close all; clear;
%% Read in image
refFrm = imread('DSC_0764.JPG');                    % Reference image

%% Define how to cut an image
num_vertStrip = 4;                                  % Number of vertical strips
num_horzStrip = 1;                                  % Number of horizontal strips
num_gridStrip = num_vertStrip * num_horzStrip;      % Number of grids in image
num_chn = 3;                                        % Number of channel in the image 

%% Create parameter for cutting image into strips
num_col_strips = repmat(size(refFrm,2)/num_vertStrip,[1 num_vertStrip]);
num_row_strips = repmat(size(refFrm,1)/num_horzStrip,[1 num_horzStrip]);
curFrm_strip = mat2cell(refFrm, num_row_strips, num_col_strips, num_chn);

%% Construct figure and windows
refFrm_figHandle = figure;      % Create refFrm figure handle
figure(refFrm_figHandle);       % Switch to refFrm handle
imshow(refFrm), truesize;       % Display the refFrm
title('Reference Image');       % Title
curFrm_figHandle = figure;      % Create curFrm figure handle
figure(curFrm_figHandle);       % Switch to curFrm handle

%% Create the sub-windows for each image strip
for i = 1:num_gridStrip
    curFrm_subplotHandle(i) = subplot(size(curFrm_strip, 1),size(curFrm_strip, 2),i);
    title(['Moving', num2str(i)]);
end

%% Display image in each sub-window
done = false;       % Boolean indicator
plot_row = 1;       % Row index
plot_col = 1;       % Column index
plot_index = 1;     % Plot index

% Loop through the entire curFrm figure handle
while(not(done))
    % Switch subplot handle, show the image
    subplot(curFrm_subplotHandle(plot_index));
    imshow(curFrm_strip{plot_row,plot_col}), truesize;
    plot_col = plot_col + 1;
    % If column reach the end, go to next row
    if (plot_col > size(curFrm_strip,2))
        plot_row = plot_row + 1;
        plot_col = 1;
        % Done with plotting, exit the loop
        if (plot_row > size(curFrm_strip,1))
            done = true;
        end
    end
    % Plot index will increment by 1 at each iteration
    plot_index = plot_index + 1;
end

%% Obtain interesting points location from user
done = false;       % Boolean indicator
plot_row = 1;       % Row index
plot_col = 1;       % Column index
plot_index = 1;     % Plot index
while(not(done))
    % Switch to subplot(sp1) handle
    figure(curFrm_figHandle);
    subplot(curFrm_subplotHandle(plot_index)), hold on;
    title('Select Point HERE', 'Color', 'Red');
    % Wait for user to select points
    [PtRefX,PtRefY] = getpts; 
    groundRef_X1Y1 = [PtRefX(1), PtRefY(1)];
    groundRef_X2Y2 = [PtRefX(2), PtRefY(2)];
    
    col_offset = sum(num_col_strips(1:plot_col)) - num_col_strips(1);
    row_offset = sum(num_row_strips(1:plot_row)) - num_row_strips(1);

    realCoor_X1Y1 = groundRef_X1Y1 + [col_offset, row_offset];
    realCoorRef_X2Y2 = groundRef_X2Y2 + [col_offset, row_offset];
    
    plot(groundRef_X1Y1(1),groundRef_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
    plot(groundRef_X2Y2(1),groundRef_X2Y2(2),'o','Color','Cyan', 'LineWidth', 3);
    line(PtRefX,PtRefY, 'Color', 'Blue', 'LineWidth', 3);
    title(['Strip[', num2str(plot_index), ']'], 'Color', 'Black');
    plot_col = plot_col + 1;
    
    figure(refFrm_figHandle);       % Switch to refFrm handle
    hold on;
    plot(realCoor_X1Y1(1),realCoor_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
    plot(realCoorRef_X2Y2(1),realCoorRef_X2Y2(2),'o','Color','Cyan', 'LineWidth', 3);
    subplot(curFrm_subplotHandle(plot_index)), hold on;

    % If column reach the end, go to next row
    if (plot_col > size(curFrm_strip,2))
        plot_row = plot_row + 1;
        plot_col = 1;
        % Done with plotting, exit the loop
        if (plot_row > size(curFrm_strip,1))
            done = true;
        end
    end
    % Plot index will increment by 1 at each iteration
    plot_index = plot_index + 1;
end