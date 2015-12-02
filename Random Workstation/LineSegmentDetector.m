%% Input image
% webcam = cv.VideoCapture(0);
pause(1);
for i = 1:2
    img = imread('Sample Images\dsc004901.jpg');%webcam.read;
    gray = cv.cvtColor(img, 'RGB2GRAY');
    %% Pre-process
    % Apply canny edge
    gray = cv.Canny(gray, [50 200], 'ApertureSize',3);

    %% LSD detectors
    % Create two LSD detectors with standard and no refinement.
    lsd = cv.LineSegmentDetector('Refine','Standard');
    % Detect the lines both ways
    lines = lsd.detect(gray);

    %% Result 1
    % Show found lines with standard refinement
    img = lsd.drawSegments(gray, lines);
    imshow(img);
end