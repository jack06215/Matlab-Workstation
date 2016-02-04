function [d,ev]=findDistances(p,PArt,PAdj,K,artSeg)

k=size(p,2);        % num planes
Kinv=inv(K);
for index=1:size(p,2)  % edit
    p(:,index)=p(:,index)/norm(p(:,index));
end

if nargin<5 % PAdj is provided with two articulations per adjacecny
    PAdj=triu(PAdj);    % adjacency matrix is symmetric
    n=2*sum(sum(PAdj));   % number of constraints

    A=zeros(n,k);
    index=1;
    for index1=1:k
        for index2=index1+1:k
            if PAdj(index1,index2)==1
                X1=Kinv*PArt(1:3,index);
                X2=Kinv*PArt(4:6,index);
                X1=X1/norm(X1); % edit
                X2=X2/norm(X2); % edit

                A(2*index-1,index1) = p(:,index2)'*X1;
                A(2*index-1,index2) = -p(:,index1)'*X1;

                A(2*index,index1) = p(:,index2)'*X2;
                A(2*index,index2) = -p(:,index1)'*X2;

                index=index+1;
            end
        end
    end
else    % artSeg is provided
    n=size(artSeg,2);
    A=zeros(n,k);
    for index=1:n
        X=Kinv*[PArt(1:2,index);1];
        X=X/norm(X); % edit
        temp=find(artSeg(:,index)>0);
        index1=temp(1);index2=temp(2);

        A(index,index1) = p(:,index2)'*X;
        A(index,index2) = -p(:,index1)'*X;
    end
end

[u,s,v]=svd(A);
% if numel(v)==4
%     d=v(:,end);
%     ev=s(end,end);
% else
%     d=v(:,end);
%     ev=s(end,end);
% end
d=v(:,end);
ev=s(end,end)/s(1,1);
