f = imread('Garfield_Building_Detroit.png');
figure, imshow(f);
line = getLines(rgb2gray(f),40);
vp = getVP3(line,size(f,1),size(f,2));
draw(f,vp,zeros(3),line);

f1 = imread('Garfield_Building_Detroit.jpg');
figure, imshow(f1);
line1 = getLines(rgb2gray(f1),40);
vp1 = getVP3(line1,size(f1,1),size(f1,2));
draw(f1,vp1,zeros(3),line1);