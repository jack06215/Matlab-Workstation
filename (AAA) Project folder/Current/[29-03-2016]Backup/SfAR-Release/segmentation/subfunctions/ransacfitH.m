% RANSACFITH based on RANSACFITDAQ
% modified to work with 2D rectification instead of 3D
%
% RANSACFITDAQ based on RANSACRECTIFY3D to fit a DAQ instead of a
% rectifying homography to multiply planar structure.
% It uses ransac3 instead of ransac2 and supplies different fitting and
% distance functions
% @input:   x,A are the same as in RANSACRECTIFY3D
% @output:  Q is a 4X4 matrix representing the best DAQ model


% RANSACRECTIFY3D based on Peter Kovesi's RANSACFITFUNDMATRIX function
% adapted for multi-planar structure rectification
% in this case the data points are the planes but the number of inliers are
% the interplanar relationships that follow the orthogonality or planarity
% the only changes are in the fitting and distance functions and the way
% inputs are routed
% @input:   x is a 4Xn matrix, n>5, for n planes
%           A is the nXn adjacency matrix
%           rest of the input is the same
% @output:  M is the 3D homography
%           inliers is a binary matrix of size nXn (for n planes) with ones
%                   indicating the inlier relationships


% RANSACFITFUNDMATRIX - fits fundamental matrix using RANSAC
%
% Usage:   [F, inliers] = ransacfitfundmatrix(x1, x2, t)
%
% Arguments:
%          x1  - 2xN or 3xN set of homogeneous points.  If the data is
%                2xN it is assumed the homogeneous scale factor is 1.
%          x2  - 2xN or 3xN set of homogeneous points such that x1<->x2.
%          t   - The distance threshold between data point and the model
%                used to decide whether a point is an inlier or not. 
%                Note that point coordinates are normalised to that their
%                mean distance from the origin is sqrt(2).  The value of
%                t should be set relative to this, say in the range 
%                0.001 - 0.01  
%
% Note that it is assumed that the matching of x1 and x2 are putative and it
% is expected that a percentage of matches will be wrong.
%
% Returns:
%          F       - The 3x3 fundamental matrix such that x2'Fx1 = 0.
%          inliers - An array of indices of the elements of x1, x2 that were
%                    the inliers for the best model.
%
% See Also: RANSAC, FUNDMATRIX

% Copyright (c) 2004-2005 Peter Kovesi
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

% February 2004  Original version
% August   2005  Distance error function changed to match changes in RANSAC

function [H, inliers, xp] = ransacfitH(x, K, A, t,s,poptype,maxTrials,maxDataTrials,talk)

    if (size(x,1)~=3)
        error('x must be a 3Xn matrix for n lines, n>2');
    end
    
    if (size(x,2)<=2)
        error('x must be a 3Xn matrix for n planes, n>2');
    end

    if nargin < 8
    	talk = 0;
    end
    if nargin < 6
        s = 2;  % Number of pairs needed to fit a H
    end
    if nargin < 7
        poptype=1;
        if talk
            disp('Default population type (i.e. adjacent lines) selected')
        end
    end
    [rows,npts] = size(x);
    

    
    fittingfn = @fitHgivenLK;
    distfn    = @findHinliers;
    degenfn   = @isdegenerate;

    [H, inliers, xp] = ransac4(x,K, A, fittingfn, distfn, degenfn, s, t,poptype, maxDataTrials, maxTrials,talk);

    % Now do a final fit on the inlier pairs
    
    
% toc;    
	

end
%----------------------------------------------------------------------
% (Degenerate!) function to determine if a set of matched points will result
% in a degeneracy in the calculation of a fundamental matrix as needed by
% RANSAC.  This function assumes this cannot happen...
     
function r = isdegenerate(x1,x2)
    r = 0;    
end