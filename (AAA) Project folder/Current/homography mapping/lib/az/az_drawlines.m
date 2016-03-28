function az_drawlines(L,axislimits,A,pointstoo)
% az_drawlines(L,axislimits,A)
% L is 3Xn or nX3, homegeneous set of n lines
% axislimits may be provided within which the lines are to be drawn
%   if axislimits is 1X4, then it is the same as provided to axis()
%   if it is an integer >=1, then it provides the handle of the figure from where to
%   get the axislimits (note, it doesn't have to be gcf)
%   if it is a positive scalar (not 1,2,3 etc), then it tells percentage of additional space
%   drawn outside the bounding box of the line intersections
% A is the line adjacency matrix over which intersections are computed, if
%   skipped all line pairs will be used
% NOTE: lines must be at least two, use hline to draw a single line
% put in azutil on 11th March 2009

if nargin<1
    error('No input given');
end
if nargin<2
    axislimits=0.1; % default percentage additional space allowed
end

if size(L,1)~=3
    L=L';
end
if size(L,1)~=3
    error('input lines must be 3Xn');
end
if size(L,2)<2
    error('at least two lines must be provided');
end
if (length(axislimits)~=1 && length(axislimits)~=4)
    error('axislimits must be a positive scalar or a 4-vector');
end
if (length(axislimits)==1 && axislimits<0)
    error('axislimits must be a positive scalar or a 4-vector');
end
if (length(axislimits)==1 && axislimits>=1)
    if round(axislimits)==axislimits
        axislimits=[get(get(axislimits,'CurrentAxes'),'Xlim'),get(get(axislimits,'CurrentAxes'),'Xlim')];
    end
end

N=size(L,2);
if nargin<3
    A=ones(N,N);
end

if nargin<4
    pointstoo=0;
end

% start processing

% axislimits;
plot(0,0,'.','visible','off');
hold on;
if length(axislimits)==1    % if axislimits are to be computed
    % compute intersection points and set the axis
    minx=inf;miny=inf;maxx=-inf;maxy=-inf;
    for index1=1:size(L,2)
        for index2=index1+1:size(L,2)
            if A(index1,index2) % if this pair is to be considered
                p=az_hcross(L(:,index1),L(:,index2));
                if pointstoo
                    plot(p(1)/p(3),p(2)/p(3),'ro');
                end
                if p(3)==1
                    minx=min(p(1),minx);
                    miny=min(p(2),miny);
                    maxx=max(p(1),maxx);
                    maxy=max(p(2),maxy);
                end
            end
        end
    end
    axislimits=[minx-axislimits*(maxx-minx),maxx+axislimits*(maxx-minx),miny-axislimits*(maxy-miny),maxy+axislimits*(maxy-miny)];
end

% set axislimits
% minx,maxx,miny,maxy
% axislimits
axis(axislimits);

% draw lines
for index=1:size(L,2)
    az_hline(L(:,index));
end
hold off;