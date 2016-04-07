function [imgNew] = my_imwarp(img, m)

%% Construct look-up table of image coordination
sz = size(img);
[rows,cols]= meshgrid(1:sz(1), 1:sz(2));
A = [reshape(cols,1,[]);
     reshape(rows,1,[]);
     ones(1,length(rows(:)))]; 
 
AA = m * A;
AA = AA ./ [AA(3,:); AA(3,:); AA(3,:)];
AA = int32(AA); % Truncate from float to int
szNew = sz;
ptYp = AA(2,:) - min(AA(2,:)) +1;
ptXp = AA(1,:) - min(AA(1,:)) +1;
szNew(1) = max(ptYp);
szNew(2) = max(ptXp);

%% Image index mapping
% ind() = y + (x - 1) * y_stride
ind = ptYp + ((ptXp - 1) * szNew(1));
indOld = A(2,:) + ((A(1,:) - 1) * sz(1));
% Create new image, with new size
imgNew = uint8(zeros(szNew(1), szNew(2),3)) * 255;

%% Map RGB color space
% Red channel = index
imgNew(ind) = img(indOld);
% Green channel = index + image size
imgNew(ind + szNew(1) * szNew(2)) = img(indOld + sz(1) * sz(2));
% Blue channel = index + 2 * (image size)
imgNew(ind + szNew(1) * szNew(2) * 2) = img(indOld + sz(1) * sz(2) * 2);

end

