im = imread('../Data/my name.bmp');
im = logical(im);
[myans] = tupperSolver(im);
disp('This is the N:');
disp(myans);
result = fopen('../k_result','w');
fprintf(result,myans);
fclose(result);