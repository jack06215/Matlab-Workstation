function adj=findadj(LS,athresh)

talk =0;

% compute alpha and beta parametrizations for the intersection points
% by solving the linear system
alpha=inf(size(LS,2));
beta=alpha;

if talk
    az_fig, axis equal;
    hold on;
    hl1=line([0,0],[0,0],'linewidth',2,'color',[0,0,1]);
    hl2=line([0,0],[0,0],'linewidth',2,'color',[0,0,1]);  
    hold off;
end

for index1=1:size(LS,2)
    for index2=index1+1:size(LS,2)
        ls1=LS(:,index1);
        ls2=LS(:,index2);
        
        v1=ls1(1:2)-ls1(3:4); v1=v1/norm(v1);
        v2=ls2(1:2)-ls2(3:4); v2=v2/norm(v2);

        if abs(acosd(v1'*v2))>=athresh
            A=[ls1(1:2)-ls1(3:4), -ls2(1:2)+ls2(3:4)];
            b=-ls1(3:4)+ls2(3:4);
            x=A\b;
            if all(isfinite(x))
                alpha(index1,index2)=x(1);
                beta(index1,index2)=x(2);
            end
        end
        if talk
            set(hl1,'XData',ls1([1,3]),'YData',ls1([2,4]));
            set(hl2,'XData',ls2([1,3]),'YData',ls2([2,4]));
            acosd(abs(v1'*v2))
            display(alpha(index1,index2));
            display(beta(index1,index2));
            pause;
        end
    end
end
adj=alpha>=-eps & alpha<=1+eps & beta>=-eps & beta<=1+eps;
adj=adj+adj';