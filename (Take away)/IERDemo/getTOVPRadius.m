function [vp_radius, foc] = getTOVPRadius(vp_theta,line,hole_radius,M,N)

point = getIntersections(line);
point(:,1) = point(:,1) - N / 2;
point(:,2) = point(:,2) - M / 2;
radius = sqrt(point(:,1).*point(:,1) + point(:,2).*point(:,2));
point = point(find(radius > hole_radius),:);
theta = atan2(point(:,2),point(:,1));

threshold = pi/180*2;
c1 = cos(vp_theta(1)); s1 = sin(vp_theta(1));
c2 = cos(vp_theta(2)); s2 = sin(vp_theta(2));
c3 = cos(vp_theta(3)); s3 = sin(vp_theta(3));
v1 = [c1;s1];
v2 = [c2;s2];
v3 = [c3;s3];

temp = mod(theta - vp_theta(1),2*pi);
temp(find(temp > pi)) = temp(find(temp > pi)) - 2*pi;
radius1 = point(find(abs(temp) < threshold),1:2)*v1;
temp = mod(theta - vp_theta(2),2*pi);
temp(find(temp > pi)) = temp(find(temp > pi)) - 2*pi;
radius2 = point(find(abs(temp) < threshold),1:2)*v2;
temp = mod(theta - vp_theta(3),2*pi);
temp(find(temp > pi)) = temp(find(temp > pi)) - 2*pi;
radius3 = point(find(abs(temp) < threshold),1:2)*v3;

d1 = sqrt(abs((-c2*c3-s2*s3)/(-c1*c2-s1*s2)/(-c1*c3-s1*s3)));
d2 = sqrt(abs((-c1*c3-s1*s3)/(-c2*c1-s2*s1)/(-c2*c3-s2*s3)));
d3 = sqrt(abs((-c1*c2-s1*s2)/(-c1*c3-s1*s3)/(-c2*c3-s2*s3)));

foc1 = radius1 ./ d1;
foc2 = radius2 ./ d2;
foc3 = radius3 ./ d3;
F = 0.7*norm([M N]):1:4*norm([M N]);
foc_bin1 = histc(foc1,F);
foc_bin2 = histc(foc2,F);
foc_bin3 = histc(foc3,F);

w1 = 1;w2 = 1;w3 = 1;
foc_bin = w1.*foc_bin1(:) + w2.*foc_bin2(:) + w3.*foc_bin3(:);
foc_bin = imfilter(foc_bin,ones(30,1)/30);
[cc,foc_ix] = max(foc_bin);
foc = F(foc_ix);

vp_radius = [d1;d2;d3] * foc;
%%
foc = [foc1;foc2;foc3];
foc = atan2(foc,M);
F = 0:0.01:2*pi;
foc_bin = histc(foc,F);
[cc,foc_ix] = max(foc_bin);
foc = F(foc_ix);
foc = tan(foc)*M;
vp_radius = [d1;d2;d3] * foc;

end