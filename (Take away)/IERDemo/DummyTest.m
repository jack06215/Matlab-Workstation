%% 0. Setup stage
close all;
img = imread('The-Equitable-Building-With-The-New-Trust-Company-Of-Georgia-Building-In-The-Background-Between-1968-And-1971-Georgia-State-University-Library.jpg');
img_bw = rgb2gray(img);
lines = DummyTest_getLines(img_bw, 40);
%% Obtain vertical lines
index = 1;
for j = 1:size(lines,1)
    angle_orientation = rad2deg(lines(j,5) + pi/2);
    if (angle_orientation >= 75 && angle_orientation <= 115)
        % plot(lines(j,1:2),lines(j,3:4),'Color','Red', 'LineWidth', 3);
        verticalLines(index,:) = lines(j,:);
        index = index + 1;
    else
        % plot(lines(j,1:2),lines(j,3:4),'Color','Blue', 'LineWidth', 3);
    end
    
    % disp([num2str(lines(j,5)), ' ', num2str(rad2deg(lines(j,5) + pi/2))]);
    % pause(0.01);
end
%% Plot the result
figure, imshow(img),hold on;
for j = 1:size(verticalLines,1)
    plot(verticalLines(j,1), verticalLines(j,3), 'o', 'Color', 'Red', 'LineWidth', 3);
    plot(verticalLines(j,2), verticalLines(j,4), 'o', 'Color', 'Cyan', 'LineWidth', 3);
    plot(verticalLines(j,1:2),verticalLines(j,3:4),'Color','Blue', 'LineWidth', 3);
end
