function [th, rad] = get3rdDegenVP(line,vp_theta,vp_radius,M,N)

if vp_radius(1) > vp_radius(2)
    vp_theta(3) = vp_theta(2) + pi;
    vp_radius(1) = inf;
else 
    vp_theta(3) = vp_theta(1) + pi;
    vp_radius(2) = inf;
end

used = zeros(size(line,1),1);
ix = findVLine(line,vp_theta(1),vp_radius(1),M,N);
used(ix) = 1;
ix = findVLine(line,vp_theta(2),vp_radius(2),M,N);
used(ix) = 1;
point = getIntersections(line(find(~used),:));
point(:,1) = point(:,1) - N / 2;
point(:,2) = point(:,2) - M / 2;

ix = zeros(2,1);
count = zeros(2,1);
R = cell(2,1);
for i = 1:2
    v = -[cos(vp_theta(i));sin(vp_theta(i))];
    proj = point(:,1:2)*v;
    radius = sqrt(point(:,1).*point(:,1) + point(:,2).*point(:,2));
    angle = acos(abs(point(:,1:2)*v./radius));

    dist = abs(point(:,1:2)*[-v(2);v(1)]);
    threshold = pi/4;
    threshold2 = 100;
    margin = 100;
    proj = proj(find(abs(angle) < threshold | dist < threshold2));
%     radius = radius(find(abs(angle) < threshold));
%     radius = radius(find(proj > -margin));
    proj = proj(find(proj > -margin));
    
    w = 0.01;
    R{i} = -pi/2 - w:w:pi/2 + w;
    if length(proj) == 0
        count(i) = 0;
        ix(i) = NaN;
    else
        proj = atan2(proj,min(M,N));
        proj_bin = histc(proj,R{i});
        proj_bin = imfilter(proj_bin,ones(10,1)/10);
        % figure, bar(proj_bin);
        [count(i), ix(i)] = max(proj_bin);
        threshold = 100;
        temp = point(:,1:2) - repmat(min(M,N)*tan(R{i}(ix(i)))*v',size(point,1),1);
        dist = sqrt(temp(:,1).*temp(:,1) + temp(:,2).*temp(:,2));
        count(i) = sum(abs(proj - R{i}(ix(i))) < threshold);
    end
    
end
threshold = 0.1;
if size(point,1) < 1 | (count(1)/size(point,1) < threshold & count(2)/size(point,1) < threshold)
    vp_radius = vp_radius(1:2);
    vp_theta = vp_theta(1:2);
else
    if count(1) > count(2)
        vp_radius(3) = min(M,N)*tan(R{1}(ix(1)));
        vp_theta(3) = vp_theta(1) + pi;
    else
        vp_radius(3) = min(M,N)*tan(R{2}(ix(2)));
        vp_theta(3) = vp_theta(2) + pi;
    end
    
    threshold = 10;
    if vp_radius(3) < threshold
        vp_radius = [inf inf 0];
    end
end

th = vp_theta;
rad = vp_radius;
end
