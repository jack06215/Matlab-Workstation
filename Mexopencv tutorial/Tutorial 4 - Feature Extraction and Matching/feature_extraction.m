clear all;
close all;

a = imread('book.pgm');
b = imread('scene.pgm');
% basmati, book, box, scene
detector = cv.FeatureDetector('SIFT');
extractor = cv.DescriptorExtractor('SIFT');

tic
keypoints1 = detector.detect(a);
descriptors1 = extractor.compute(a, keypoints1);
keypoints2 = detector.detect(b);
descriptors2 = extractor.compute(b, keypoints2);
toc

index_pairs = matchFeatures(descriptors1,descriptors2);

matchpoints1 = [];
matchpoints2 = [];
for i = index_pairs(:,1)'
    matchpoints1 = [matchpoints1 keypoints1(i).pt'];
end
for i = index_pairs(:,2)'
    matchpoints2 = [matchpoints2 keypoints2(i).pt'];
end

figure;
subplot(121);
imshow(a);
hold on; scatter(matchpoints1(1,:),matchpoints1(2,:),'yo','LineWidth',2);
subplot(122);
imshow(b);
hold on; scatter(matchpoints2(1,:),matchpoints2(2,:),'yo','LineWidth',2);
