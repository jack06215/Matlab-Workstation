function [myans,x_width,y_height] = tupperSolver(im)
%tupperSolver: Compute the N value in tupper's self referential formula
%   Input
%       im: Grayscale image
%   Output
%       myans: k value
%       x_width: image width
%       y_height: image height
im = logical(im);
im = imrotate(im, 180); % Conversion issue, by rotating 180 degree counterwise
[m,n] = size(im);
y_height = m;
x_width  = n;
im2lr = fliplr(im);
num = im2lr(:);
charmap(num==true)   = '0';%white means 0 rather than 1 (in binary map).
charmap(num==false) = '1';%black means 1.Ref: See17 change into 3, you will see what i mean.

digitB = digit_transfer(2,10,charmap);
myans = bign(digitB,num2str(y_height));
end

