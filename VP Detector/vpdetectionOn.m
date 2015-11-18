function [im, lines, labels] = vpdetectionOn(imname, imnameGray)
im=imread(imname);
%gim = rgb2gray(im);
[lines, labels]=vpdetection(imnameGray);
drawVPGroup(imnameGray,lines,labels);
end


