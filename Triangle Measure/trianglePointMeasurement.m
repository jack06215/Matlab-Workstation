%% Define 2 sets of vanishing point
vanishingPtsA = [-50, -70;
                150, 250;
                300, 10];
            
vanishingptsB = [50, -70;
                150, 150;
                300, 70];
            
movingPtsA = [149, 30;
              130, 25;
              150, 10;
              179, 100
              180, 70;
              110, 54];
[ movingPtsB ] = triangleMeasure( movingPtsA, vanishingPtsA, vanishingptsB  );
%% Plot figure for demonstration purpose
figure(1), hold on;
xlim([-100,500]);
ylim([-100,500]);
daspect([1 1 1]);
% Triangular formed by three vanishing points A
%plot(vanishingPtsA(:,1), vanishingPtsA(:,2), 'x', 'Color', 'Green', 'MarkerSize', 15, 'LineWidth', 2);
plot([vanishingPtsA(1,1), vanishingPtsA(2,1)], [vanishingPtsA(1,2), vanishingPtsA(2,2)], '-', 'Color', 'Green', 'LineWidth', 2);
plot([vanishingPtsA(1,1), vanishingPtsA(3,1)], [vanishingPtsA(1,2), vanishingPtsA(3,2)], '-', 'Color', 'Green', 'LineWidth', 2);
plot([vanishingPtsA(2,1), vanishingPtsA(3,1)], [vanishingPtsA(2,2), vanishingPtsA(3,2)], '-', 'Color', 'Green', 'LineWidth', 2);

% Triangular formed by three vanishing points B
%plot(vanishingptsB(:,1), vanishingptsB(:,2), 'x', 'Color', 'Red', 'MarkerSize', 15, 'LineWidth', 2);
plot([vanishingptsB(1,1), vanishingptsB(2,1)], [vanishingptsB(1,2), vanishingptsB(2,2)], '-', 'Color', 'Red', 'LineWidth', 2);
plot([vanishingptsB(1,1), vanishingptsB(3,1)], [vanishingptsB(1,2), vanishingptsB(3,2)], '-', 'Color', 'Red', 'LineWidth', 2);
plot([vanishingptsB(2,1), vanishingptsB(3,1)], [vanishingptsB(2,2), vanishingptsB(3,2)], '-', 'Color', 'Red', 'LineWidth', 2);

% Moving points bounded by vanishing points A
plot(movingPtsA(:,1), movingPtsA(:,2), 'x', 'Color', 'Black', 'MarkerSize', 15, 'LineWidth', 2);

% Moving points bounded by vanishing points B
plot(movingPtsB(:,1), movingPtsB(:,2), 'x', 'Color', 'Cyan', 'MarkerSize', 15, 'LineWidth', 2);
% [tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(movingPtsA, movingPtsB, 'affine');