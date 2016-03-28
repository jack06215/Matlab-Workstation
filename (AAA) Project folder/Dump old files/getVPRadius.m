function radius = getVPRadius(point,foc0)

if size(point,1) == 0
    radius = NaN;
    return;
end
radius = sqrt(point(:,1).*point(:,1) + point(:,2).*point(:,2));
radius = atan2(radius,foc0);

w = 0.01;
R = 0:w:pi/2 + w;
radius_bin = histc(radius,R);
if sum(radius_bin) == 0
    radius = NaN;
    return;
end

radius_bin = imfilter(radius_bin,ones(5,1)/5);
% figure, bar(radius_bin);
[cc, ix] = max(radius_bin);

radius = R(ix);
radius = foc0*tan(radius);

end