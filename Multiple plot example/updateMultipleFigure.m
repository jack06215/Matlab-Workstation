img = imread('DSC_0764.JPG');
img2 = imread('DSC_0765.JPG');

figImg = figure;
imshow(img);
figImg2 = figure;
imshow(img2);
truesize;

for i = 1:3
    figure(figImg), hold on;
    [PtRefX,PtRefY] = getpts;
    groundRef_X1Y1 = [PtRefX(1), PtRefY(1), 0];
    groundRef_X2Y2 = [PtRefX(2), PtRefY(2), 0];
    plot(groundRef_X1Y1(1),groundRef_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
    plot(groundRef_X2Y2(1),groundRef_X2Y2(2),'o','Color','Yellow', 'LineWidth', 3);
    line(PtRefX,PtRefY, 'Color', 'Blue', 'LineWidth', 3);
    figure(figImg2), hold on;
    % subplot(1,2,2), hold on;
    plot(groundRef_X1Y1(1),groundRef_X1Y1(2),'o','Color','Yellow', 'LineWidth', 3);
    plot(groundRef_X2Y2(1),groundRef_X2Y2(2),'o','Color','Yellow', 'LineWidth', 3);
    line(PtRefX,PtRefY, 'Color', 'Blue', 'LineWidth', 3);
end