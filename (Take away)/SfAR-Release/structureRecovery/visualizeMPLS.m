function visualizeMPLS(L,seg,t,X,Xseg)

% L is the 6XN (or 8XN) matrix of N Line segments (2point form) in D3 (or P3)
% seg is a kXN matrix and gives the segmentation of lines into planes
%   s(i,j)=1, if the j-th lines belongs to i-th plane, 0 otherwise
% t [optional] is the time to orbit, in miliseconds
% X [optional] 3XM or 4XM for M points in 3D
% Xseg is a kXM matrix and gives the segmentation of points into planes

if nargin<3
    t=0; %time to orbit, miliseconds
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
if size(L,1)==8
    L(1:3,:)=L(1:3,:)./repmat(L(4,:),3,1);
    L(5:7,:)=L(5:7,:)./repmat(L(8,:),3,1);
    L=L([1,2,3,5,6,7],:);
elseif size(L,1)~=6
    error('L must be 6XN or 8XN for N lines')
end
if nargin<4
    X=[];
elseif size(X,1)==4
    X(1:3,:)=X(1:3,:)./repmat(X(4,:),3,1);
elseif size(X,1)~=3
    error('X must be 3XM or 4XM for M points')
end

k = size(seg,1);

% visualize the data by ploting all the 3D line segments
view(-37.5,30);
hold on;
for index=1:k
    planecol=cmat(mod(index,NUMColors)+1,:); % select a color for this plane
    Lp = L(:,seg(index,:)>0);   % select the lines on the current plane
%     disp(Lp)
    % plot the lines
    for index2=1:size(Lp,2)
        l2p = Lp(:,index2);    % pick the current line
        plot3([l2p(1),l2p(4)],[l2p(2),l2p(5)],[l2p(3),l2p(6)],'color',planecol)
    end
    % plot the points
    if ~isempty(X)
        Xp=X(:,Xseg(index,:)>0);
        plot3(Xp(1,:),Xp(2,:),Xp(3,:),'.','color',planecol);
    end
%     pause;
end
hold off;

axis equal;
for index=2:10:t
    camorbit(1,-0.5,'camera')
    drawnow
    pause(0.01)
end

axis equal;

if t<1
    H=get(0,'currentfigure');
%     while ishandle(H)
%         if get(0,'currentfigure')==H
%             camorbit(1,-0.5,'camera')
%             drawnow
%         end
%         pause(0.01)
%     end
end
