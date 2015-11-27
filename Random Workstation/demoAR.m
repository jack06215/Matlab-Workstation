%% Load reference image, detect SURF points, and extract descriptors
referenceImage = imread('Sample Images\PyramidPattern.jpg');

% Detect and extract SURF features
referenceImageGray = rgb2gray(referenceImage);
referencePts = detectSURFFeatures(referenceImageGray);

referenceFeatures = extractFeatures(referenceImageGray, referencePts);

%% Dsplay SURF features for a reference image

figure;
imshow(referenceImage), hold on;
title('Reference Image');
plot(referencePts.selectStrongest(50));

%% Initialise replacement video
video = vision.VideoFileReader('Sample Images\MAH00019.avi');

% camera = webcam('FJ Camera');
% set(camera, 'Resolution', '640x480');

%% Detect SURF features in webcam frame
%cameraFrame = snapshot(camera);
cameraFrame = imread('Sample Images\PyramidPatternTest.jpg');
cameraFeatureGray = rgb2gray(cameraFrame);
cameraPts = detectSURFFeatures(cameraFeatureGray);

figure;
imshow(cameraFrame), hold on;
title('Webcam frame');
plot(cameraPts.selectStrongest(50));

%% Try to match the reference image and camera frame features
cameraFeatures = extractFeatures(cameraFeatureGray, cameraPts);
idxPairs = matchFeatures(cameraFeatures, referenceFeatures);

% Store the SRUF points that were matched
matchedCameraPts = cameraPts(idxPairs(:,1));
matchedReferencePts = referencePts(idxPairs(:,2));

figure, hold on;
title('Matched feature (with outliers)');
showMatchedFeatures(cameraFrame, referenceImage, ...
                    matchedCameraPts, matchedReferencePts, 'Montage');
                
%% Get geometric transfomration between reference image and webcam frame
[referenceTransform, inlierReferencePts, inlierCameraPts] ...
    = estimateGeometricTransform(...
                matchedReferencePts, matchedCameraPts, 'Similarity');
% Show the inliers of the estimated geometric transfomration
figure(), hold on;
showMatchedFeatures(cameraFrame, referenceImage,...
                    inlierCameraPts, inlierReferencePts, 'Montage');
%% Rescale replacement video frame

% Load replacement video frame
videoFrame = im2uint8(step(video));

% Get replacement and reference dimensions
repDims = size(videoFrame(:,:,1));
refDims = size(referenceImage(:,:,1));

% Find transformation that scales video frame to replace image size,
% preserving aspect ratio
% scaleTransform = findScaleTransform(refDims, repDims);
scaleTransform = [570/1080, 0, 0;
                  0, 600/1920, 0;
                  0, 0, 1];
              
transHomoT = transpose(scaleTransform);
transMat = projective2d(transHomoT);

videoFrameScaled = imwarp(videoFrame, transMat);
figure(), hold on;
imshowpair(cameraFrame, videoFrameScaled, 'Montage');

%% Apply estimated geometric transform to scaled replecement video frame
videoFrameTransformed = imwarp(videoFrameScaled, referenceTransform);
figure(), hold on;
imshowpair(cameraFrame, videoFrameTransformed, 'Montage');

%% Insert transformed replecement video frame into webcam frame

alphaBlender = vision.AlphaBlender(...
    'Operation', 'Binary mask', 'MaskSource', 'Input port');

mask = videoFrameTransformed(:,:,1) | ...
       videoFrameTransformed(:,:,2) | ...
       videoFrameTransformed(:,:,3) > 0;
outputFrame = step(alphaBlender, cameraFrame, videoFrameTransformed , mask);

figure(), hold on;
imshow(outputFrame);

% %% Initialise Point Tracker
% 
% pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
% initialize(pointTracker, inlierReferencePts.Location, cameraFrame);
% 
% % Display the points being used for tracking
% trackingMarkers = insertMarker(cameraFrame, inlierReferencePts.Location, ...
%                                 'Size', 7, 'Color', 'Yellow');
%                             
% figure(), hold on;
% imshow(trackingMarkers);
% 
% %% Track points to next frame
% % Store previous frame just for visual comparison
% prevCameraFrame = cameraFrame;
% 
% % Get nexgt webcam frame
% cameraFrame = snapshot(camera);
% [trackedPoints, isValid] = step(pointTracker, cameraFrame);
% 
% % Using only the locations that have been reliably tracked
% newValidLocations = trackedPoints(isValid,:);
% oldValidLocations = inlierCameraPts.Location(isValid,:);
% 
% %% Estimate geometric transformation between two frames
% 
% if (nnz(isValid) >= 2) % Must have at least 2 points between frames
%     [trackingTransform, oldInlierLocations, newInlierLocation] = ...
%         estimateGeometricTransform(...
%             oldInlierLocations, newInlierLocation, 'Similarity');
% end
% 
% % Show the valid of the geometric transformation
% figure(), hold on;
% showMatchedFeatures(prevCameraFrame, cameraFrame, ...
%     oldInlierLocations, newInlierLocation, 'Montage');
% 
% % Reset Point Tracker for tracking in next frame
% setPoints(pointTracker, newValidLocations);
% 
% %% Accumulate geogetric transformation fomr reference to current frame
% 
% trackingTransform.T = referenceTransform.T * trackingTransform.T;
% 
% %% Rescale new replacement video frame
% repFrame = step(video);
% 
% videoFrameScaled = imwarp(videoFrame, scaleTransform);
% 
% figure(), hold on;
% imshowpair(referenceImage, videoFrameScaled, 'Montage');
% 
% %% Apply total geometric transformation to new replacement video frame
% 
% videoFrameTransformed = imwarp(videoFrameScaled, trackingTransform);
% figure(), hold on;
% imshowpair(cameraFrame, videoFrameTransformed, 'Montage');
% 
% %% Insert transformed replecement frame into webcam input
% 
% mask = videoFrameTransformed(:,:,1) | ...
%        videoFrameTransformed(:,:,2) | ...
%        videoFrameTransformed(:,:,3) > 0;
% outputFrame = step(alphaBlender, cameraFrame, videoFrameTransformed , mask);
% figure(), hold on;
% imshow(outputFrame);

%% Finally Clean up
release(video);
% delete(camera);

