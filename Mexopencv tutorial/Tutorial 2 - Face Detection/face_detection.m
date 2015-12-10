% Load a face detector and an image
detector = cv.CascadeClassifier('haarcascade_frontalface_alt.xml');
im = imread('family.png');
% Preprocess
gr = cv.cvtColor(im, 'RGB2GRAY');
gr = cv.equalizeHist(gr);
% Detect
boxes = detector.detect(gr, 'ScaleFactor',  1.3, ...
                            'MinNeighbors', 2, ...
                            'MinSize',      [30, 30]);
% Draw results
imshow(im);
for i = 1:numel(boxes)
    rectangle('Position',  boxes{i}, ...
              'EdgeColor', 'g', 'LineWidth', 2);
end