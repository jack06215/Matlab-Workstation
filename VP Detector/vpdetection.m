function [lines,labels]=vpdetection(img)
% get line segments from lsd
tic
lines = lsd(img);
t = toc;
disp(['[lsd] ',num2str(t),' seconds elapsed.']);

% save lines to a file for excutable vpdetection to use
save('lines.tmp', 'lines', '-ascii', '-tabs');

% vpdetection
disp(['[vpdetection] begin, might take a while, please wait...']);
tic
[status, result] = system('vpdetection lines.tmp lines.out')
t = toc;
disp(['[vpdetection] end, ',num2str(t),' seconds elapsed.']);

out = load('lines.out');
lines = out(:,1:4);
labels = uint8(out(:,5)+1); %make label subscripts starts from 1
end

