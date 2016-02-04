function [a,ao]=findDistancesNew(p,PArt,PAdj,K,artSeg)

k=size(p,2);        % num planes
Kinv=inv(K);
for index=1:size(p,2)  % edit
    p(:,index)=p(:,index)/norm(p(:,index));     %normalize plane normals
end
  index=1;
  index1=1;
  index2=index1+1;
            
                A=zeros(1,2);
                XAll=Kinv*PArt(1:3,:);          %project 1st half points to 3D-Rays
                a=zeros(2,size(PArt,2));
                for i=1:size(PArt,2)
                    X1=XAll(1:3,i);             %pick a 3d ray and normalize it
                    X1=X1/norm(X1); % edit
                A(1,index1) = p(:,index2)'*X1;  %Pi' * X1(3d ray) 
                A(1,index2) = -p(:,index1)'*X1; 
                d=null(A);                      %[eq 6]
                planes=[p;d'];                  %PI
%                 tolk=1;
%                 if i==0
%                     tolk=1;
%                 end
               a(1,i)=getAngle(planes, PArt(:,i),K);
%                ,tolk);
%                if tolk
%                    a(1,i)
%                end
                if ~rem(i,50)
                        %fprintf(1,'line#%d\n',i);
                    end
                
                end
                
                XAll=Kinv*PArt(4:6,:);
%                 a=zeros(2,size(PArt,2));
                for i=1:size(PArt,2)
                    X1=XAll(1:3,i);
                    X1=X1/norm(X1); % edit
                A(1,index1) = p(:,index2)'*X1;
                A(1,index2) = -p(:,index1)'*X1;
                d=null(A);
                planes=[p;d'];
%                 tolk=1;
%                 if i==0
%                     tolk=1;
%                 end
               a(2,i)=getAngle(planes, PArt(:,i),K);
%                ,tolk);
%                if tolk
%                    a(2,i)
%                end
                if ~rem(i,50)
                        %fprintf(1,'line#%d\n',i);
                    end
                
                end
                ao=a;
                a=min(a);
%                pause
end          
