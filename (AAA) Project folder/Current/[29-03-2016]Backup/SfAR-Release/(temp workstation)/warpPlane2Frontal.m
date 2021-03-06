%% Obtain the homography that warp a image plane to its frontal view
% Obtain alpha and beta rotation parameters of the first plane
ax=X(1);ay=X(2);
% Make the rotation matrix
R1=makehgtform('xrotate',ax,'yrotate',ay); 
R1=R1(1:3,1:3);
% Obtain the homography
C_center = [1,0, -center(1);
            0,1, -center(2);
            0,0,1];
H1= K*(R1/K)*C_center;
% H1= inv(K*C_center*R1'*inv(K*C_center));
%% Calclating Resultant Translation and Scale
% A rectangle boundary that defined a image width and height
Rect = [0,0,1; size(im,2),0,1; size(im,2),size(im,1),1; 0,size(im,1),1]';
% Perform prespective transformation based o the homography matrix
Rect_out = homoTrans(H1, Rect);
%% Scalling
scale_fac = abs((max(Rect_out(1,2), Rect_out(1,3))- min(Rect_out(1,1), Rect_out(1,4)))/size(im,2));
Rect_out = Rect_out./repmat(scale_fac,3,4);
Rect_out(1,2) = Rect_out(1,2) - Rect_out(1,1);
Rect_out(2,2) = Rect_out(2,2) - Rect_out(2,1);
Rect_out(1,3) = Rect_out(1,3) - Rect_out(1,1);
Rect_out(2,3) = Rect_out(2,3) - Rect_out(2,1);
Rect_out(1,4) = Rect_out(1,4) - Rect_out(1,1);
Rect_out(2,4) = Rect_out(2,4) - Rect_out(2,1);
Rect_out(1,1) = Rect_out(1,1) - Rect_out(1,1);
Rect_out(2,1) = Rect_out(2,1) - Rect_out(2,1);

Rect = Rect(1:2,:)'; 
Rect_out = Rect_out(1:2,:)';

T = fitgeotrans(Rect,Rect_out,'projective');
im_new = imwarp(im, T');
hFig=[hFig az_fig];
set(hFig(1,end),'Name','Gap Filled and Extended Lines');
imagesc(im_new), axis equal;

