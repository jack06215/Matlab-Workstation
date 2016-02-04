function [vp_t,vp_r] = getCenterVP(point,M,N)
if size(point,1) == 0
    vp_t = NaN;
    vp_r = NaN;
    return;
end

w = 10;
X = min(point(:,1)):w:max(point(:,1));
Y = min(point(:,2)):w:max(point(:,2));

x_bin = zeros(length(X),1);
y_bin = zeros(length(Y),1);
x_sqs = zeros(length(X),1);
y_sqs = zeros(length(Y),1);
x_sum = zeros(length(X),1);
y_sum = zeros(length(Y),1);

x_label = [point(:,1) ...
    point(:,2) point(:,2).*point(:,2)];
y_label = [point(:,2) ...
    point(:,1) point(:,1).*point(:,1)];

[c,ix] = sort(x_label(:,1));
x_label = x_label(ix,:);
[c,iy] = sort(y_label(:,1));
y_label = y_label(iy,:);
ix = [0; cumsum(histc(x_label(:,1),X))];
iy = [0; cumsum(histc(y_label(:,1),Y))];
for i = 2:length(ix)
    x_bin(i - 1) = ix(i) - ix(i - 1);
    x_sum(i - 1) = sum(x_label(ix(i - 1) + 1:ix(i),2));
    x_sqs(i - 1) = sum(x_label(ix(i - 1) + 1:ix(i),3));
end
for i = 2:length(iy)
    y_bin(i - 1) = iy(i) - iy(i - 1);
    y_sum(i - 1) = sum(y_label(iy(i - 1) + 1:iy(i),2));
    y_sqs(i - 1) = sum(y_label(iy(i - 1) + 1:iy(i),3));
end

% x_bin = imfilter(x_bin,[1;1;1],'circular');
% x_sqs = imfilter(x_sqs,[1;1;1],'circular');
% x_sum = imfilter(x_sum,[1;1;1],'circular');
% y_bin = imfilter(y_bin,[1;1;1],'circular');
% y_sqs = imfilter(y_sqs,[1;1;1],'circular');
% y_sum = imfilter(y_sum,[1;1;1],'circular');

x_std = x_sqs./x_bin - (x_sum./x_bin).^2;
y_std = y_sqs./y_bin - (y_sum./y_bin).^2;

threshold = max(size(point,1)/length(X),2);
ix = x_bin < threshold;
threshold = max(size(point,1)/length(Y),2);
iy = y_bin < threshold;

x_bin = x_bin./x_std;
y_bin = y_bin./y_std;
x_bin(ix) = 0;
y_bin(iy) = 0;

x_bin = imfilter(x_bin,[1;1;1],'circular');
y_bin = imfilter(y_bin,[1;1;1],'circular');

[mx,ix] = max(x_bin);
[my,iy] = max(y_bin);

vp_t = atan2(Y(iy),X(ix));
vp_r = norm([Y(iy),X(ix)]);
end