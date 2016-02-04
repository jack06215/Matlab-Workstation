function xp = optimize(PArt_im_c,L_im,K,Xnew,seg,inliers,artSeg,segAdj)

xp=[K(1,1);Xnew(:)];
options=optimset( 'Display', 'iter', 'MaxIter', 2000, 'TolFun', 10^-200, 'TolX', 10^-10,'MaxFunEvals',10^20);
xp = fminunc(@artOrthSVR,xp,options,L_im,seg,inliers,PArt_im_c,artSeg,segAdj );
