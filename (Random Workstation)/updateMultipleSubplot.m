close all; clear;
%% Read in image
refFrm = imread('curFrm.png');                    % Reference image
curFrm = imread('outImg.png');                    % Curent image

%% Define how to cut an image
num_vertStrip = 2;                                  % Number of vertical strips
num_horzStrip = 1;                                  % Number of horizontal strips
num_gridStrip = num_vertStrip * num_horzStrip;      % Number of grids in image
num_chn = 3;                                        % Number of channel in the image 

%% Create parameter for cutting image into strips
num_col_strips = repmat(size(curFrm,2)/num_vertStrip,[1 num_vertStrip]);
num_row_strips = repmat(size(curFrm,1)/num_horzStrip,[1 num_horzStrip]);
curFrm_strip = mat2cell(curFrm, num_row_strips, num_col_strips, num_chn);

%% Construct figure and windows
refFrm_figHandle = figure;              % Create refFrm figure handle
figure(refFrm_figHandle);               % Switch to refFrm figure handle
imshow(refFrm), truesize;               % Display the refFrm
title('Reference Image');               % Title

curFrm_figHandle = figure;              % Create curFrm figure handle
figure(curFrm_figHandle);               % Switch to curFrm handle
imshow(curFrm), truesize;               % Display the curFrm
title('Current Image');                 % Title

curFrm_strip_figHandle = figure;        % Create curFrm strip handle
figure(curFrm_strip_figHandle);         % Switch to curFrm strip handle
curFrm_subplotHandle = zeros(num_gridStrip);

%% Create the sub-windows for each image strip
for i = 1:num_gridStrip
    curFrm_subplotHandle(i) = subplot(size(curFrm_strip, 1),size(curFrm_strip, 2),i);
    title(['Moving', num2str(i)]);
end

%% Display image in each sub-window
done = false;       % Boolean indicator
plot_row = 1;       % Row index
plot_col = 1;       % Column index
plot_index = 0;     % Plot index

% Loop through the entire curFrm figure handle
while(not(done))
    plot_index = plot_index + 1; 
    % Switch subplot handle, show the image
    subplot(curFrm_subplotHandle(plot_index));
    imshow(curFrm_strip{plot_row,plot_col}), truesize;
    
    % ((((This part handle the image strip indexing))))
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
end

%% Obtain interesting points location from user
done = false;       % Boolean indicator
plot_row = 1;       % Row index
plot_col = 1;       % Column index
plot_index = 1;     % Plot index
DEFAULT_SIZE = 100;
list_size = DEFAULT_SIZE;
curFrm_point = zeros(DEFAULT_SIZE, 2);
% curFrm_point = [];
curFrm_ptr = 1;
while(not(done))
    % disp(['[', num2str(plot_row), ', ', num2str(plot_col), ']']);
    figure(curFrm_strip_figHandle);
    subplot(curFrm_subplotHandle(plot_index)), hold on;
    title('Select Point HERE', 'Color', 'Red');
    % Wait for user to select points
    [PtRefX,PtRefY] = getpts;
    if (size(PtRefX,1) > 0 && size(PtRefY,1) > 0)
        groundRef_X1Y1 = [PtRefX(1), PtRefY(1)];
        groundRef_X2Y2 = [PtRefX(2), PtRefY(2)];
        % Offset the image strip's coordinate system to match up with refFrm
        col_offset = sum(num_col_strips(1:plot_col)) - num_col_strips(1);
        row_offset = sum(num_row_strips(1:plot_row)) - num_row_strips(1);
        realCoor_X1Y1 = groundRef_X1Y1 + [col_offset, row_offset];
        realCoor_X2Y2 = groundRef_X2Y2 + [col_offset, row_offset];

        % Store the pixel location
        curFrm_point(curFrm_ptr,:) = realCoor_X1Y1;
        curFrm_point(curFrm_ptr + 1,:) = realCoor_X2Y2;
        curFrm_ptr = curFrm_ptr + 2;
%         curFrm_point = [curFrm_point;realCoor_X1Y1];
%         curFrm_point = [curFrm_point;realCoor_X2Y2];
        
        plot(groundRef_X1Y1(1),groundRef_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
        plot(groundRef_X2Y2(1),groundRef_X2Y2(2),'o','Color','Cyan', 'LineWidth', 3);      
        % Switch to refFrm handle and draw result
        figure(curFrm_figHandle);       
        hold on;
        plot(realCoor_X1Y1(1),realCoor_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
        plot(realCoor_X2Y2(1),realCoor_X2Y2(2),'o','Color','Cyan', 'LineWidth', 3);
    else
        subplot(curFrm_subplotHandle(plot_index)), hold on;
        title(['Strip[', num2str(plot_index), ']'], 'Color', 'Black');
        % ((((This part handle the image strip indexing))))
        plot_index = plot_index + 1;
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
    end
    % add new block of memory if needed
    if( curFrm_ptr+(DEFAULT_SIZE/10) > curFrm_ptr )  % less than 10%*BLOCK_SIZE free slots
        list_size = list_size + DEFAULT_SIZE;       % add new BLOCK_SIZE slots
        curFrm_point(curFrm_ptr+1:list_size,:) = 0;
    end
end
curFrm_point(curFrm_ptr:end,:) = []; 
% figure(curFrm_figHandle);       
% hold on;
% j = 1;
% for i = 1:2:size(curFrm_point,1)
%     plot(curFrm_point(i,1), curFrm_point(i, 2),'o','Color','Yellow', 'LineWidth', 3);
%     plot(curFrm_point(i + 1, 1), curFrm_point(i + 1, 2),'o','Color','Cyan', 'LineWidth', 3);
% end
%% Obtain point from reference frame
figure(refFrm_figHandle);               % Switch to refFrm figure handle
hold on;
done = false;
DEFAULT_SIZE = 100;
list_size = DEFAULT_SIZE;
refFrm_point = zeros(DEFAULT_SIZE, 2);
% refFrm_point = [];
refFrm_ptr = 1;
while(not(done))
    title('Select Point HERE', 'Color', 'Red');
    [PtRefX,PtRefY] = getpts;
    if (size(PtRefX,1) > 0 && size(PtRefY,1) > 0)
        groundRef_X1Y1 = [PtRefX(1), PtRefY(1)];
        groundRef_X2Y2 = [PtRefX(2), PtRefY(2)];
        plot(groundRef_X1Y1(1),groundRef_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
        plot(groundRef_X2Y2(1),groundRef_X2Y2(2),'o','Color','Cyan', 'LineWidth', 3);
        refFrm_point(refFrm_ptr,:) = groundRef_X1Y1;
        refFrm_point(refFrm_ptr + 1,:) = groundRef_X2Y2;
        refFrm_ptr = refFrm_ptr + 2;
%         refFrm_point = [refFrm_point; groundRef_X1Y1]; 
%         refFrm_point = [refFrm_point; groundRef_X2Y2];
        
    else
        title('Reference Image', 'Color', 'Black');
        done = true;
    end
    % add new block of memory if needed
    if( refFrm_ptr+(DEFAULT_SIZE/10) > refFrm_ptr )  % less than 10%*BLOCK_SIZE free slots
        list_size = list_size + DEFAULT_SIZE;       % add new BLOCK_SIZE slots
        refFrm_point(refFrm_ptr+1:list_size,:) = 0;
    end
end
refFrm_point(refFrm_ptr:end,:) = [];
% figure(refFrm_figHandle);       
% hold on;
% j = 1;
% for i = 1:2:size(refFrm_point,1)
%     plot(refFrm_point(i,1), refFrm_point(i, 2),'o','Color','Yellow', 'LineWidth', 3);
%     plot(refFrm_point(i + 1, 1), refFrm_point(i + 1, 2),'o','Color','Cyan', 'LineWidth', 3);
% end
%% Estimate Geometric Transformation
if (size(curFrm_point,1) > 0 && size(refFrm_point, 1) > 0)
    tform = estimateGeometricTransform(refFrm_point, curFrm_point, 'affine');
    outImg = imwarp(curFrm_strip{1,2}, tform);
    figure;
    imshow(outImg);
else
    error('Empty vector is not allowed');
end
