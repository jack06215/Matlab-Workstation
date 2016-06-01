%% Construct homography matrix
ax=X3(4);ay=X3(5);az=X3(6);
% ax=X(1);ay=X(2);az=0.6;
flag1 = ax >= 1 || ax <= -1;
flag2 = ay >= 1 || ay <= -1;
% flag3 = az >
R1=makehgtform('xrotate',ax,'yrotate',ay, 'zrotate',az); 
R1=R1(1:3,1:3);
C_center = [1,0, -center(1);
            0,1, -center(2);
            0,0,1];
H1= K*(R1/K)*C_center;
s = norm(H1(:,2)) / norm(H1(:,1));
%%
% s = norm(H1(:,2)) / norm(H1(:,1));
% A_s = [1,1/s,1];
% AA_s = diag(A_s);
% H1 = H1 * AA_s;

%


%% Calclating Resultant Translation and Scale
Rect = [0,0,1; size(im,2),0,1; size(im,2),size(im,1),1; 0,size(im,1),1]';
Rect_out = homoTrans(H1, Rect);
% bb = repmat(Rect_out_1(3),3,4);
% Rect_out = Rect_out_1;%./bb;
%% Fix scaling, based on length.
scale_fac = abs((max(Rect_out(1,2), Rect_out(1,3))- min(Rect_out(1,1), Rect_out(1,4)))/size(im,2));
Rect_out = Rect_out./repmat(scale_fac,3,4);
%% Shift the Rect_out back to "pixel coordinate" w.r.t. Rect
Rect_out(1,2) = Rect_out(1,2) - Rect_out(1,1);
Rect_out(2,2) = Rect_out(2,2) - Rect_out(2,1);
Rect_out(1,3) = Rect_out(1,3) - Rect_out(1,1);
Rect_out(2,3) = Rect_out(2,3) - Rect_out(2,1);
Rect_out(1,4) = Rect_out(1,4) - Rect_out(1,1);
Rect_out(2,4) = Rect_out(2,4) - Rect_out(2,1);
Rect_out(1,1) = Rect_out(1,1) - Rect_out(1,1);
Rect_out(2,1) = Rect_out(2,1) - Rect_out(2,1);
% Conversion: dropping off the 'w coordinate', and transpose
Rect = Rect(1:2,:)'; 
Rect_out = Rect_out(1:2,:)';
%% Fit geometric transform between Rect and Rect_out
T = fitgeotrans(Rect,Rect_out,'projective');
im_new = imwarp(im, T');
hFig=[hFig az_fig];
set(hFig(1,end),'Name','Gap Filled and Extended Lines');
imagesc(im_new), axis equal;
