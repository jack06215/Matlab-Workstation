function [vp, foc, time] = getVP3(line,M,N)
tic
hole_radius = norm([M N])/2;    % Principle point
used = zeros(size(line,1),1);
vp_theta = zeros(3,1);
vp_radius = zeros(3,1);
vp_weight = zeros(3,1);
hole_used = false;
for i = 1:2
    point = getIntersections(line(~used,:));
    point(:,1) = point(:,1) - N / 2;
    point(:,2) = point(:,2) - M / 2;
    radius = sqrt(point(:,1).*point(:,1) + point(:,2).*point(:,2));
    if ~hole_used
        point0 = point(radius <= 2*hole_radius,:);
        [vp_t0 vp_r0] = getCenterVP(point0,M,N);
        ix0 = findVLine(line(~used,:),vp_t0,vp_r0,M,N);
        vp_w0 = length(ix0);
    else
        vp_w0 = 0;
    end
    point1 = point(radius > hole_radius,:);
    [vp_t1 ix1] = getVPTheta(point1);
    point1 = point1(ix1,:);
    vp_r1 = getVPRadius(point1,min(M,N));
    ix1 = findVLine(line,vp_t1,vp_r1,M,N);
    vp_w1 = length(ix1);
    
    if vp_w1 < vp_w0
        vp_theta(i) = vp_t0;
        vp_radius(i) = vp_r0;
        vp_weight(i) = vp_w0;
        used(ix0) = 1;
        hole_used = true;
    else
        vp_theta(i) = vp_t1;
        vp_radius(i) = vp_r1;
        vp_weight(i) = vp_w1;
        used(ix1) = 1;
    end
end

% vp = [vp_radius.*cos(vp_theta) vp_radius.*sin(vp_theta) ones(3,1)];

angle = mod(vp_theta(1) - vp_theta(2),2*pi);
if angle > pi
    angle = 2*pi - angle;
end
threshold = pi/180;
if angle < pi/2 - 10*threshold
    fprintf('There may be some Non-TOVPs.\n');
    vp = [vp_radius(1:2).*cos(vp_theta(1:2)) vp_radius(1:2).*sin(vp_theta(1:2)) ones(2,1)];
    foc = -1;
elseif (angle >= pi/2 - 10*threshold & angle < pi/2 + 3*threshold)
    if mod(vp_theta(2) - vp_theta(1),2*pi) < pi
        vp_theta(2) = vp_theta(1) + pi/2;
    else
        vp_theta(2) = vp_theta(1) - pi/2;
    end
    [vp_theta vp_radius] = get3rdDegenVP(line(~used,:),vp_theta,vp_radius,M,N);
    if length(vp_theta) == 3
        vp(3,:) = [vp_radius(3).*cos(vp_theta(3)) vp_radius(3).*sin(vp_theta(3)) 1];
        if vp_radius(1) < inf
            vp(1,:) = [vp_radius(1).*cos(vp_theta(1)) vp_radius(1).*sin(vp_theta(1)) 1];
            vp(2,:) = [cos(vp_theta(2)) sin(vp_theta(2)) 0];
            foc = sqrt(vp_radius(3)*vp_radius(1));
        elseif vp_radius(2) < inf
            vp(1,:) = [cos(vp_theta(1)) sin(vp_theta(1)) 0];
            vp(2,:) = [vp_radius(2).*cos(vp_theta(2)) vp_radius(2).*sin(vp_theta(2)) 1];
            foc = sqrt(vp_radius(3)*vp_radius(2));
        else
            vp(1,:) = [cos(vp_theta(1)) sin(vp_theta(1)) 0];
            vp(2,:) = [cos(vp_theta(2)) sin(vp_theta(2)) 0];
            foc = 0;
        end
        ix = findVLine(line,vp_theta(3),vp_radius(3),M,N);
        vp_weight(3) = length(ix);     
    else
        foc = -1;
        vp = [vp_radius.*cos(vp_theta) vp_radius.*sin(vp_theta) ones(2,1)];
        if vp_radius(1) == inf
            vp(1,:) = [cos(vp_theta(1)) sin(vp_theta(1)) 0];
        elseif vp_radius(2) == inf
            vp(2,:) = [cos(vp_theta(2)) sin(vp_theta(2)) 0];
        end
        vp_weight(3) = 0;
    end
    
elseif angle > pi - 3*threshold
    vp_theta(2) = vp_theta(1) + pi;
    vp = [vp_radius.*cos(vp_theta) vp_radius.*sin(vp_theta) ones(3,1)];
    [vp_theta vp_radius] = get3rdDegenVP2(line,vp_theta,vp_radius,M,N);
    vp(3,:) = [cos(vp_theta(3)) sin(vp_theta(3)) 0];
    foc = sqrt(vp_radius(1)*vp_radius(2));
    ix = findVLine(line,vp_theta(3),vp_radius(3),M,N);
    vp_weight(3) = length(ix);
    
else
    foc = sqrt(-vp_radius(1)*vp_radius(2)*cos(vp_theta(1) - vp_theta(2)));
    vp = [vp_radius(1:2).*cos(vp_theta(1:2)) vp_radius(1:2).*sin(vp_theta(1:2)) ones(2,1)];
    vp(3,:) = [((-vp(1:2,1:2))^(-1) * [foc*foc;foc*foc])' 1];
    vp_radius(3) = sqrt(vp(3,1)*vp(3,1) + vp(3,2)*vp(3,2));
    vp_theta(3) = atan2(vp(3,2),vp(3,1));
    
    if vp_radius(3) >= 0 & vp_radius(3) < hole_radius*2 & ~hole_used
        point = getIntersections(line(~used,:));
        point(:,1) = point(:,1) - N / 2;
        point(:,2) = point(:,2) - M / 2;
        temp = point(:,1:2) - repmat(vp(3,1:2),size(point,1),1);
        dist = sqrt(temp(:,1).^2 + temp(:,2).^2);
        threshold = hole_radius;
        point = point(dist < threshold,:);
        [vp_theta(3) vp_radius(3)] = getCenterVP(point,M,N);
        vp = [vp_radius.*cos(vp_theta) vp_radius.*sin(vp_theta) ones(3,1)];
        ix = findVLine(line,vp_theta(3),vp_radius(3),M,N);
        vp_weight(3) = length(ix);
    elseif vp_radius(3) >hole_radius
        point = getIntersections(line(~used,:));
        point(:,1) = point(:,1) - N / 2;
        point(:,2) = point(:,2) - M / 2;
        radius = sqrt(point(:,1).*point(:,1) + point(:,2).*point(:,2));
        point = point(radius > hole_radius,:);
        angle = atan2(point(:,2),point(:,1));
        angle = mod(angle - vp_theta(3),2*pi);
        angle(angle > pi) = 2*pi - angle(angle > pi);
        point = point(angle < pi/18,:);
        [vp_theta(3) ix] = getVPTheta(point);
        point = point(ix,:);
        vp_radius(3) = getVPRadius(point,min(M,N));
        vp = [vp_radius.*cos(vp_theta) vp_radius.*sin(vp_theta) ones(3,1)];
        ix = findVLine(line,vp_theta(3),vp_radius(3),M,N);
        vp_weight(3) = length(ix);
    else
        vp = vp(1:2,:);
    end
end
vp = vp(vp_weight(1:size(vp,1))>0,:);
% vp = reCal(vp,line,M,N);
time = toc;

vp_theta = atan2(vp(:,2),vp(:,1));
vp_radius = sqrt(vp(:,1).^2 + vp(:,2).^2);
if size(vp,1) == 3 & isTOVP(vp_theta,vp_radius)
    [vp_radius foc] = getTOVPRadius(vp_theta,line,hole_radius,M,N);
% elseif sum(vp(:,3) == 0) == 1
%     r = vp_radius(vp(:,3) == 1);
%     foc = sqrt(r(1)*r(2));
else    
    foc = -1;
end
