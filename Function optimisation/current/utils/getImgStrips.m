function [imgStrips] = getImgStrips(img,num_col,num_rol)
if nargin < 3
    num_rol = 1;
end

num_chn = size(img,3);

col_cut = repmat(size(img,2)/num_col,[1 num_col]);
row_cut = repmat(size(img,1)/num_rol,[1 num_rol]);
imgStrips = mat2cell(img, row_cut, col_cut, num_chn);
end

