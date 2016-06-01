function [line, vanishing, point, foc] = detectTOVP(f)
line = getLines(f,40);
point = zeros((size(line,1) - 1)*size(line,1)/2,2);
count = 0;
for i = 1:size(line,1)
    for j = i + 1:size(line,1)
        theta1 = line(i,5);
        theta2 = line(j,5);
        rho1 = line(i,6);
        rho2 = line(j,6);
        x = (rho1 * cos(theta2) - rho2 * cos(theta1)) / ...
            sin(theta1 - theta2);
        y = (rho1 * sin(theta2) - rho2 * sin(theta1)) / ...
            sin(theta2 - theta1);
        count = count + 1;
        point(count,1) = y;
        point(count,2) = x;
    end
end
point = point(1:count,:);
point(:,1) = point(:,1) - size(f,2) / 2;
point(:,2) = point(:,2) - size(f,1) / 2;

radius = sqrt(point(:,1).*point(:,1) + point(:,2).*point(:,2));
point = point(find(radius > norm(size(f))/2),:);
theta = atan2(point(:,2),point(:,1));
T = -pi:0.01:pi;

theta_bin = histc(theta,T);
% figure,bar(theta_bin)
% tb = theta_bin;

nhood =  60;
dec = 1;
[~, ix1] = max(theta_bin);
theta_bin(max(ix1-nhood,1):min(ix1+nhood,length(T))) = 0;
if ix1 + nhood > length(T)
    theta_bin(1:mod(ix1 + nhood,length(T))) = 0;
elseif ix1 - nhood < 1
    theta_bin(mod(ix1 - nhood - 1,length(T)):length(T)) = 0;
end

temp = ix1;
ix1 = mod(ix1 + round(length(T)/2),length(T));
theta_bin(max(ix1-nhood,1):min(ix1+nhood,length(T))) = dec*theta_bin(max(ix1-nhood,1):min(ix1+nhood,length(T)));
if ix1 + nhood > length(T)
    theta_bin(1:mod(ix1 + nhood,length(T))) = dec*theta_bin(1:mod(ix1 + nhood,length(T)));
elseif ix1 - nhood < 1
    theta_bin(mod(ix1 - nhood - 1,length(T)):length(T)) = dec*theta_bin(mod(ix1 - nhood - 1,length(T)):length(T));
end
ix1 = temp;


[~, ix2] = max(theta_bin);
theta_bin(max(ix2-nhood,1):min(ix2+nhood,length(T))) = 0;
if ix2 + nhood > length(T)
    theta_bin(1:mod(ix2 + nhood,length(T))) = 0;
elseif ix2 - nhood < 1
    theta_bin(mod(ix2 - nhood - 1,length(T)):length(T)) = 0;
end

temp = ix2;
ix2 = mod(ix2 + round(length(T)/2),length(T));
theta_bin(max(ix2-nhood,1):min(ix2+nhood,length(T))) = dec*theta_bin(max(ix2-nhood,1):min(ix2+nhood,length(T)));
if ix2 + nhood > length(T)
    theta_bin(1:mod(ix2 + nhood,length(T))) = dec*theta_bin(1:mod(ix2 + nhood,length(T)));
elseif ix2 - nhood < 1
    theta_bin(mod(ix2 - nhood - 1,length(T)):length(T)) = dec*theta_bin(mod(ix2 - nhood - 1,length(T)):length(T));
end
ix2 = temp;


[~, ix3] = max(theta_bin);
theta_bin(max(ix3-nhood,1):min(ix3+nhood,length(T))) = 0;
if ix3 + nhood > length(T)
    theta_bin(1:mod(ix3 + nhood,length(T))) = 0;
elseif ix3 - nhood < 1
    theta_bin(mod(ix3 - nhood - 1,length(T)):length(T)) = 0;
end

temp = ix3;
ix3 = mod(ix3 + round(length(T)/2),length(T));
theta_bin(max(ix3-nhood,1):min(ix3+nhood,length(T))) = dec*theta_bin(max(ix3-nhood,1):min(ix3+nhood,length(T)));
if ix3 + nhood > length(T)
    theta_bin(1:mod(ix3 + nhood,length(T))) = dec*theta_bin(1:mod(ix3 + nhood,length(T)));
elseif ix3 - nhood < 1
    theta_bin(mod(ix3 - nhood - 1,length(T)):length(T)) = dec*theta_bin(mod(ix3 - nhood - 1,length(T)):length(T));
end
ix3 = temp;


% plot(ix1,1,'s');plot(ix2,1,'s');plot(ix3,1,'s');
c1 = cos(T(ix1));
c2 = cos(T(ix2));
c3 = cos(T(ix3));
s1 = sin(T(ix1));
s2 = sin(T(ix2));
s3 = sin(T(ix3));


n1 = [c1;s1];
n2 = [c2;s2];
n3 = [c3;s3];
proj = repmat(point*n1,1,2).*repmat(n1',size(point,1),1);
temp = point - proj;
dist = sqrt(temp(:,1).*temp(:,1) + temp(:,2).*temp(:,2));
len = sqrt(point(:,1).*point(:,1) + point(:,2).*point(:,2));
ratio = dist./ len;
threshold = 0.26;
proj = proj(find(ratio < threshold),:);
proj = proj(find(proj(:,1)*n1(1) > 0),:);
proj1 = proj;

proj = repmat(point*n2,1,2).*repmat(n2',size(point,1),1);
temp = point - proj;
dist = sqrt(temp(:,1).*temp(:,1) + temp(:,2).*temp(:,2));
len = sqrt(point(:,1).*point(:,1) + point(:,2).*point(:,2));
ratio = dist./ len;
threshold = 0.26;
proj = proj(find(ratio < threshold),:);
proj = proj(find(proj(:,1)*n2(1) > 0),:);
temp = proj*n2;
proj2 = proj;

proj = repmat(point*n3,1,2).*repmat(n3',size(point,1),1);
temp = point - proj;
dist = sqrt(temp(:,1).*temp(:,1) + temp(:,2).*temp(:,2));
len = sqrt(point(:,1).*point(:,1) + point(:,2).*point(:,2));
ratio = dist./ len;
threshold = 0.26;
proj = proj(find(ratio < threshold),:);
proj = proj(find(proj(:,1)*n3(1) > 0),:);
temp = proj*n3;
proj3 = proj;

dist1 = sqrt(proj1(:,1).*proj1(:,1) + proj1(:,2).*proj1(:,2));
dist2 = sqrt(proj2(:,1).*proj2(:,1) + proj2(:,2).*proj2(:,2));
dist3 = sqrt(proj3(:,1).*proj3(:,1) + proj3(:,2).*proj3(:,2));

d1 = sqrt(abs((-c2*c3-s2*s3)/(-c1*c2-s1*s2)/(-c1*c3-s1*s3)));
d2 = sqrt(abs((-c1*c3-s1*s3)/(-c2*c1-s2*s1)/(-c2*c3-s2*s3)));
d3 = sqrt(abs((-c1*c2-s1*s2)/(-c1*c3-s1*s3)/(-c2*c3-s2*s3)));

foc1 = dist1 ./ d1;
foc2 = dist2 ./ d2;
foc3 = dist3 ./ d3;
F = 0.7*norm(size(f)):1:4*norm(size(f));
foc_bin1 = histc(foc1,F);
foc_bin2 = histc(foc2,F);
foc_bin3 = histc(foc3,F);
w1 = 1;w2 = 1;w3 = 1;
foc_bin = w1.*foc_bin1 + w2.*foc_bin2 + w3.*foc_bin3;
fb1 = foc_bin;
foc_bin = imfilter(foc_bin,ones(30,1)/30);
[~,foc_ix] = max(foc_bin);
foc = F(foc_ix);

vanishing = [foc*d1*n1';
    foc*d2*n2';
    foc*d3*n3'];
end

