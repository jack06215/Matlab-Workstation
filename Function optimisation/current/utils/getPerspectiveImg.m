function [im_new,T] = getPerspectiveImg(img,x,K,center)
ax=x(1);ay=x(2);
if nargin < 4
    center = [size(img,2)/2; size(img,1)/2];
end
R1=makehgtform('xrotate',ax,'yrotate',ay); 
R1=R1(1:3,1:3);
C_center = [1,0, -center(1);
            0,1, -center(2);
            0,0,1];
H1= K*(R1/K)*C_center;
%% Calclating Resultant Translation and Scale
Rect = [0,0,1; size(img,2),0,1; size(img,2),size(img,1),1; 0,size(img,1),1]';
Rect_out = homoTrans(H1, Rect);
%% Fix scaling, based on length.
scale_fac = abs((max(Rect_out(1,2), Rect_out(1,3))- min(Rect_out(1,1), Rect_out(1,4)))/size(img,2));
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
im_new = imwarp(img, T');
end

