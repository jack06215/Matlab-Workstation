clear all;
webcam = cv.VideoCapture(0);
pause(1);
while true
    img = webcam.read;
    gray = cv.cvtColor(img, 'RGB2GRAY');
    %% Run FeatureDetector
    sift = cv.FeatureDetector('ORB');
    keypoints = sift.detect(gray);
    %% Result
    img = cv.drawKeypoints(img, keypoints);
    imshow(img);
end