function point = getIntersections(line)
point = zeros((size(line,1) - 1)*size(line,1)/2,4);
count = 0;
for i = 1:size(line,1)
    for j = i + 1:size(line,1)
        theta1 = line(i,5);
        theta2 = line(j,5);
        if abs(theta1 - theta2) < eps
            theta1 = theta2 + eps;
        end
        rho1 = line(i,6);
        rho2 = line(j,6);
        x = (rho1 * cos(theta2) - rho2 * cos(theta1)) / ...
            sin(theta1 - theta2);
        y = (rho1 * sin(theta2) - rho2 * sin(theta1)) / ...
            sin(theta2 - theta1);
        count = count + 1;
        point(count,1) = x;
        point(count,2) = y;
        point(count,3) = i;
        point(count,4) = j;
    end
end
point = point(1:count,:);
end