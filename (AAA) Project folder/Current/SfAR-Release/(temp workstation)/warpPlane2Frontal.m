%% Construct homography matrix
ax=X3(1);ay=X3(2);az=X3(3);
R1=makehgtform('xrotate',ax,'yrotate',ay, 'zrotate',az); 
R1=R1(1:3,1:3);
img_center = [1,0, -center(1); 0,1, -center(2); 0,0,1];
H1= K*(R1/K)*img_center;
%% Calclating resultant translation and scale
Rect = [0,0,1; size(im,2),0,1; size(im,2),size(im,1),1; 0,size(im,1),1]';
Rect_out(1,1) = Rect_out(1,1) - Rect_out(1,1);
Rect_prespective = homoTrans(H1, Rect);
%% Fix scaling, based on width
scale_fac = abs((max(Rect_prespective(1,2), Rect_prespective(1,3))- min(Rect_prespective(1,1), Rect_prespective(1,4)))/size(im,2));
Rect_prespective = Rect_prespective./repmat(scale_fac,3,4);
%% Shift the Rect_out baconfig.swiftt.com
