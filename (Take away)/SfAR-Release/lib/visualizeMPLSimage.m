function visualizeMPLSimage(L,seg,axislimits,pointstoo)
% az_drawtwoptslines(L,seg,pointstoo,axislimits)
% L is 6Xn or 4Xn, n line segments in two-points format
% seg is a kXN vector and gives the segmentation of lines into planes
%   s(i,j)=1, if the j-th lines belongs to i-th plane, 0 otherwise
% axislimits [optional] may be provided within which the lines are to be drawn
%   if axislimits is 1X4, then it is the same as provided to axis()
%   if it is an integer >=1, then it provides the handle of the figure from where to
%   get the axislimits (note, it doesn't have to be gcf)
%   if it is a positive scalar (not 1,2,3 etc), then it tells percentage of additional space
%   drawn outside the bounding box of the line intersections
% pointstoo [optional] tells whether to draw the points too
% put in azutil on 12th June 2009

if nargin<1
    error('No input given');
end
if nargin<2
    seg=ones(1,size(L,2));
end
if nargin<3
    axislimits=0.1; % default percentage additional space allowed
end
if nargin<4
    pointstoo=0; % default no points are drawn
end

% set up color code matrix
cmat=[1,0,1;...
    1,0,0;...
    0,1,0;...
    0,0,1;...
    0,0,0;...
    1,1,0;...
    0,1,1;];
NUMColors = size(cmat,1);

% preprocess L
if size(L,1)==6
    L=[L(1:2,:)./repmat(L(3,:),2,1); L(4:5,:)./repmat(L(6,:),2,1)];
elseif size(L,1)~=4
    error('L must be 4XN or 6XN for N 2D line segments');
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

% start processing
hold on;
if length(axislimits)==1    % if axislimits are to be computed
    % compute the image limits and set the axislimits
    minx=min([L(1,:),L(3,:)]);
    maxx=max([L(1,:),L(3,:)]);
    miny=min([L(2,:),L(4,:)]);
    maxy=max([L(2,:),L(4,:)]);
    
    axislimits=[minx-axislimits*(maxx-minx),maxx+axislimits*(maxx-minx),miny-axislimits*(maxy-miny),maxy+axislimits*(maxy-miny)];

    % set axislimits
    axis(axislimits);
end

% draw line segments and points
k = size(seg,1);
for index=1:k
    planecol=cmat(mod(index,NUMColors)+1,:); % select a color for this plane
    Lp = L(:,seg(index,:)>0);   % select the lines on the current plane
    % plot the line segments
    for index2=1:size(Lp,2)
        l2p = Lp(:,index2);    % pick the current line
        plot([l2p(1),l2p(3)],[l2p(2),l2p(4)],'color',planecol)
        if pointstoo % if the points are also to be drawn
            plot([l2p(1),l2p(3)],[l2p(2),l2p(4)],'x','color',planecol)
        end
    end
%     pause;
end
hold off;