close all; clear all; clc;

[im,lines,labels]=vpdetectionOn('./images/test.jpg', './images/testGray.jpg');
print('indoor.jpg','-dpng');

disp('press any key to continue...');