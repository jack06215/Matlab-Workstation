function [tupper] = tupperBitmap(myans)
%tupperBitmap: recover the bitmap from the formula, with the designated N value
%   Detailed explanation goes here
%% Recover the bitmap from the formula, with the designated N value
% Use the symbolic toolbox to represent the big integer k
k =  sym(myans);
[x,y] = meshgrid(0:1:106, 0:1:16);
% Evaluate the tupper formula
tupper = rem(floor(floor((y+k)/17) .* 2.^(-17*x - rem((y+k), 17))), 2);
% Convert from symbolic to Matlab's native double precision
tupper = double(tupper);
tupper = fliplr((1-tupper)*255);
end

