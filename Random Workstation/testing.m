origin = [0, 0, 0];
ref = [1, 0, 0];
groundA = [205, 110, 0];
groundB = [41, 147, 0];

fitref = polyfit([origin(1), ref(1)], [origin(2), ref(2)], 1);
fitmm = polyfit([origin(1), groundA(1)], [origin(2), groundA(2)], 1);
fitnn = polyfit([origin(1), groundB(1)], [origin(2), groundB(2)], 1);

angleA = atan((fitmm(1) - fitref(1)) / (1 + (fitmm(1)* fitref(1))));
disp(['Angle ref-mm rotate ', num2str(rad2deg(angleA)), ' degree']);
angleB = atan((fitnn(1) - fitref(1)) / (1 + (fitnn(1)* fitref(1))));
disp(['Angle ref-nn rotate ', num2str(rad2deg(angleB)), ' degree']);
angleAB_diff = angleB - angleA;
disp(['Angle mm-nn difference is ', num2str(rad2deg(angleAB_diff)), ' degree']);

%% Draw Result
% Graph setting
hold on;
daspect([1 1 1]);
% % Draw L1 (Reference unit vector)
% plot(ref(1), ref(2), 'o', 'color', 'r', 'linewidth', 3);
% L_ref = line([origin(1) ref(1)], [origin(2) ref(2)], 'color', 'red', 'linewidth', 5);
% Draw L2
plot(groundA(1), groundA(2), 'o', 'color', 'r', 'linewidth', 3);
L_groundA = line([origin(1) groundA(1)], [origin(2) groundA(2)], 'color', 'blue', 'linewidth', 3);
% Draw L3
plot(groundB(1), groundB(2), 'o', 'color', 'r', 'linewidth', 3);
L_groundB = line([origin(1) groundB(1)], [origin(2) groundB(2)], 'color', 'black', 'linewidth', 3);
% Show legend
legend([L_groundA, L_groundB], 'Ground A', 'Ground B');
