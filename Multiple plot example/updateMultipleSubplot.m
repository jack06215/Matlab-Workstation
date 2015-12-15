close all; clear;
%% Read in image
img = imread('DSC_0764.JPG');
img2 = imread('DSC_0765.JPG');

%% Create two figures with subplots
sp1 = subplot(1,2,1);
imshow(img);
title('Original');
sp2 = subplot(1,2,2);
imshow(img2);
title('Moving');
truesize;

% Here we store points selected by the users
refPoint = [];
movingPoint = [];
for i = 1:3
    
    %% Switch to subplot(sp1) handle 
    
    % Wait for user to select points
    subplot(sp1), hold on;
    [PtRefX,PtRefY] = getpts; 
    groundRef_X1Y1 = [PtRefX(1), PtRefY(1)];
    groundRef_X2Y2 = [PtRefX(2), PtRefY(2)];
    refPoint(i:i+1, 1:2) = [groundRef_X1Y1; groundRef_X2Y2];
    % Plot the points and a line connection
    plot(groundRef_X1Y1(1),groundRef_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
    plot(groundRef_X2Y2(1),groundRef_X2Y2(2),'o','Color','Yellow', 'LineWidth', 3);
    line(PtRefX,PtRefY, 'Color', 'Blue', 'LineWidth', 3);
    
    %% Switch to subplot(sp2) handle
    
    % Wait for user to select points
    subplot(sp2), hold on;
    [PtCurX,PtCurY] = getpts;
    groundCur_X1Y1 = [PtCurX(1), PtCurY(1)];
    groundCur_X2Y2 = [PtCurX(2), PtCurY(2)];
    movingPoint(i:i+1, 1:2) = [groundCur_X1Y1; groundCur_X2Y2];
    % Plot the points and a line connection    
    plot(groundCur_X1Y1(1),groundCur_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
    plot(groundCur_X2Y2(1),groundCur_X2Y2(2),'o','Color','Yellow', 'LineWidth', 3);
    line(PtCurX,PtCurY, 'Color', 'Blue', 'LineWidth', 3);
end
