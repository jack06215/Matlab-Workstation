%% Read in an image, run through the edge detector
testImg = imread('Sample Images\fig2.jpg');
figure;
imshow(testImg);
thetaSampleFrequency = 1/500; % Define the precision of rotation to be captured(0-pi)
testImg = rgb2gray(testImg);
BW = edge(testImg, 'canny');

%% Hough Transform starts from here
% Define the hough space
tic;
BW = flipud(BW);
[width,height] = size(BW);
rhoLimit = norm([width height]);
rho = (-rhoLimit:1:rhoLimit);          
theta = (0:thetaSampleFrequency:pi);
numThetas = numel(theta);
houghSpace = zeros(numel(rho),numThetas);
 
% Find the "edge" pixels
[xIndicies,yIndicies] = find(BW);
 
% Pre-allocate space for the accumulator array
numEdgePixels = numel(xIndicies);
accumulator = zeros(numEdgePixels,numThetas);
 
% Pre-allocate cosine and sine calculations to increase speed. In
% addition to pre-callculating sine and cosine we are also multiplying
% them by the proper pixel weights such that the rows will be indexed by 
% the pixel number and the columns will be indexed by the thetas.
% Example: cosine(3,:) is 2*cosine(0 to pi)
%         cosine(:,1) is (0 to width of image)*cosine(0)
cosine = (0:width-1)'*cos(theta); % Matrix Outerproduct  
sine = (0:height-1)'*sin(theta); % Matrix Outerproduct

accumulator((1:numEdgePixels),:) = cosine(xIndicies,:) + sine(yIndicies,:);

% Scan over the thetas and bin the rhos 
for i = (1:numThetas)
    houghSpace(:,i) = hist(accumulator(:,i),rho);
end
toc;
figure();
pcolor(theta,rho,houghSpace);
shading flat;
title('Hough Transform');
xlabel('Theta (radians)');
ylabel('Rho (pixels)');
colormap(parula(5));