addpath('C:\tools\mexopencv');
addpath(genpath('.'));
close all;
image = cv.imread('./data/lucky_star_hiragana_wall_chart_by_muddy_mudkip.jpg');
gray = cv.cvtColor(image,'BGR2GRAY');
sobel = cv.Sobel(gray,'XOrder',1,'YOrder',0);


img_th = cv.threshold(sobel,'Otsu','MaxValue',255,'Type','Binary');
kernel = cv.getStructuringElement('Shape','Rect','KSize',[17,3]);
% dilated  = cv.dilate(img_th,'Element',kernel,'Iterations',13);
morph = cv.morphologyEx(img_th,'Close','Element',kernel);
[contours, hierarchy] = cv.findContours(img_th, ...
    'Mode','External', 'Method','Simple');

find(cellfun('length',contours)>100);
figure, imshow(image);
figure, imshow(morph);