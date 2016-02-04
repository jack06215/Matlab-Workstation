function showLS(LS,linecolor,linewidth)

if nargin<3
    linewidth=2;
end
if nargin<2
    linecolor=[1,0,0];
end


hold on;
if size(LS,1)==6    % 3D Line segments
    for index=1:size(LS,2)
        plot3(LS([1,4],index),LS([2,5],index),LS([3,6],index),'-','color',linecolor,'linewidth',linewidth);
    end
else    % otherwise, they must be 2D Line segments
    for index=1:size(LS,2)
        plot(LS([1,3],index),LS([2,4],index),'-','color',linecolor,'linewidth',linewidth);
    end
end
hold off;