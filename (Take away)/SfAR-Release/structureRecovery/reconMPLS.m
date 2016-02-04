function [L,PArt]=reconMPLS(L_im_2p,PArt_im,seg,artSeg,K,p)

if size(L_im_2p,1)==4
    L_im_2p=[L_im_2p(1:2,:);ones(1,size(L_im_2p,2));L_im_2p(3:4,:);ones(1,size(L_im_2p,2))];
end
if size(PArt_im,1)==2
    PArt_im=[PArt_im(1:2,:);ones(1,size(PArt_im,2))];
end

Kinv=inv(K);
L=zeros(6,size(L_im_2p,2));

for index=1:size(L_im_2p,2)
    if any(seg(:,index))
        X1=Kinv*L_im_2p(1:3,index);
        X2=Kinv*L_im_2p(4:6,index);

    %     index,p,seg(:,index)

        v=p(:,seg(:,index)>0); d=v(4); v=v(1:3);

    %     size(v),size(X1),size(X2)
        lamb1 = d/(v(:)'*X1);
        lamb2 = d/(v(:)'*X2);

        L(:,index)=[lamb1*X1;lamb2*X2];
    end
end

PArt=zeros(3,size(L_im_2p,2));
for index=1:size(PArt_im,2)
    X=Kinv*PArt_im(1:3,index);
    
    v=p(:,artSeg(:,index)>0); v=v(:,1);
    d=v(4); v=v(1:3);
    
    lamb = d/(v'*X);
    
    PArt(:,index)=lamb*X;
end

