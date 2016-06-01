function [X,Y] = main_test

S.fH = figure('menubar','none');
im = imread( 'fig1.jpg' );

S.aH = axes;
S.iH = imshow( im ); hold on
axis image;

X = [];
Y = [];

set(S.aH,'ButtonDownFcn',@startDragFcn);
set(S.iH,'ButtonDownFcn',@startDragFcn);
set(S.fH, 'WindowButtonUpFcn', @stopDragFcn);
plot(X,Y,'r','LineWidth',6,'ButtonDownFcn',@startDragFcn);

function startDragFcn(varargin)
    set( S.fH, 'WindowButtonMotionFcn', @draggingFcn );
    pt = get(S.aH, 'CurrentPoint');
    x = pt(1,1);
    y = pt(1,2);
    X = x;
    Y = y;
end

function draggingFcn(varargin)
    pt = get(S.aH, 'CurrentPoint');
    x = pt(1,1);
    y = pt(1,2);
    X = [X x];
    Y = [Y y];

    plot(X,Y,'r','LineWidth',6,'ButtonDownFcn',@startDragFcn)
    hold on
    drawnow 
end

function stopDragFcn(varargin)
    set(S.fH, 'WindowButtonMotionFcn', '');  %eliminate fcn on release
end

end

