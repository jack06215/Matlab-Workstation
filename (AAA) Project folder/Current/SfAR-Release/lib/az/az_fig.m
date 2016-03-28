function Hout=az_fig(H)
% function to create a figure which fills almost 80% area of the screen
% handle can be provided as input and/or output
scrsz = get(0,'ScreenSize');
if nargin<1
    H=figure('Position',[0.1*scrsz(3) 0.05*scrsz(4) 0.8*scrsz(3) 0.85*scrsz(4)]);
else
    figure(H);
    set(H,'Position',[0.1*scrsz(3) 0.05*scrsz(4) 0.8*scrsz(3) 0.85*scrsz(4)]);
end
if nargout>0
    Hout=H;
end