% generates 2D index from a 1D index for column major order but missing the
% major diagonal... to be used for interplanar relationships.. since
% diagonal entries contain a plane's relationship with itself...
% npts is the number of planes, k is the linear index

function [r,c]=get2DIndex(npts,k)
    k = k-1;
    c = fix(k/(npts-1))+1;
    r = mod(k,npts-1)+1;
    r(find(r>=c))=r(find(r>=c))+1;