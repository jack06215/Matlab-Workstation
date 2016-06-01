close all;
%% Read value from file
result = fopen('../k_result','r');
myans = fscanf(result,'%s');
fclose(result);
%% Number of copy in rows and cols
row_replicate = 1;
col_replicate = 1;
%% Recover the bitmap from the formula, with the designated N value
[tupper] = tupperBitmap(myans);
%% Plot the recover bitmap image
tupper_rep = repmat(tupper,row_replicate,col_replicate);
figure, imshow(tupper_rep,'initialMagnification',800);
image(tupper_rep);
axis equal
title('Tupper''s self-referential formula');
set(gca, 'XTick', [], 'YTick', []);

