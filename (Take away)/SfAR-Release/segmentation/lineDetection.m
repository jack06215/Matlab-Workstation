function [LS,Ladj,LS_c,L,hFig] = lineDetection(im,center,LSDscale,gapfillflag,extendflag,maxlines,athreshgap,dthreshgap,athreshadj,talk)
%LINEDETECTION 
% inputs
% im: image
% LSDscale: scale parameter for the lsd line detector
% gapfillflag: true: fill gaps between lines
% extendflag: true: extend lines
% u0 v0: image center
% outputs
% LS: detected line segments, gap filled and extended
% Ladj: adjacency matrix for line segments
% LS_c: detected line segments in the center coordinates
% L: line segments in vector format
% hFig: the handle of the figures drawn

%%
% detect and preprocess the lines
[LS,~,Ladj,hFig]=getLSadj(im,LSDscale,gapfillflag,extendflag,maxlines,athreshgap,dthreshgap,athreshadj,talk);  % LS denotes a segment defined by two points
                                                        % x suffix is for extended line segments
% Ladj=triu(Ladj);    % since Ladj is symmetric, only triu matters

LS_c=LS-repmat(center,2,size(LS,2));       % move origin to the princple point
%     LSx_c=LSx-repmat([u0;v0],2,size(LSx,2));    % _c is for centered origin

L=twopts2L(LS_c);   % convert line segments to vector format for rectification
                    % no _c for L since lines in vector format will
                    % always be centered


end

