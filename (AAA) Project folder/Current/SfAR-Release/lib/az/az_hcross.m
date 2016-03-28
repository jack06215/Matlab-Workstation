% AZ_HCROSS - Homogeneous cross product, result normalised to s = 1.
% edited by az 11March09 so that output is not normalized if h=0....
% input argument checks added
% put in azutil on 11th March 2009
%
% HCROSS - Homogeneous cross product, result normalised to s = 1.
%
% Function to form cross product between two points, or lines,
% in homogeneous coodinates.  The result is normalised to lie
% in the scale = 1 plane.
% 
% Usage: c = hcross(a,b)
%

% Copyright (c) 2000-2005 Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% http://www.csse.uwa.edu.au/
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

%  April 2000

function c = az_hcross(a,b)

if nargin<2
    error('Two points needed');
end
if (any(isnan(a)) || any(isinf(a)) || any(isnan(b)) || any(isinf(b)))
    error('Invalid points');
end

c = cross(a,b);
if c(3)
    c = c/c(3);
end
