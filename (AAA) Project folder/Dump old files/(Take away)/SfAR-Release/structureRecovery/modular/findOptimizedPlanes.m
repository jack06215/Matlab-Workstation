function planes = findOptimizedPlanes(xp,no_of_segs,PArt_im_c,segAdj,Kp,artSeg)

planes = findOptimizedPlanesVector(xp,no_of_segs);
d=findDistances(planes(1:3,:),PArt_im_c,segAdj,Kp,artSeg);
planes=[planes;d'];
