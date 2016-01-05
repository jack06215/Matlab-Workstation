function [th, ix] = getVPTheta(point)

if size(point,1) == 0
    th = NaN;
    ix = [];
    return;
end
theta = atan2(point(:,2),point(:,1));

% Create the theta-histogram
T = -pi:0.01:pi;
theta_bin = histc(theta,T);
theta_bin = imfilter(theta_bin,ones(3,1)/3);

% figure,bar(theta_bin),hold on

[cc, ix] = max(theta_bin);

th = T(ix);
threshold = pi/180*5;
temp = mod(theta - th,2*pi);
temp(temp > pi) = temp(temp > pi) - 2*pi;
ix = find(abs(temp) < threshold);
end