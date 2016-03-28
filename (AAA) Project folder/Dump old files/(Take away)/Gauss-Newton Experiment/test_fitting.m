close all;
%% Generate the synthetic data from the curve function with some additional noise
x1 = 100;
x2 = 102;
xdata = [0:0.1:15];    % Sampling range and frequency
ydata = x1 * sin(x2 * xdata) + x2 * cos(x1 * xdata);

% Add some noise to the input sample
ydata_noise = ydata + (5 * rand(length(xdata),1))';
 
% Declare a anonymous function 
fun = @(x,xdata)x(1)* sin(x(2) * xdata) + x(2) * cos(x(1) * xdata);
% InitialvertBot_locationY guess 
x0 = [100.5,102.5];

%% 
options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt', 'Display', 'iter');
lb = [];
ub = [];
x = lsqcurvefit(fun,x0,xdata,ydata_noise,lb,ub,options);


%% Plot result
times = linspace(xdata(1),xdata(end));
figure, hold on;
inputData = plot(xdata,ydata,'-', 'Color', 'Black', 'LineWidth', 2);
inputData_noise = plot(xdata,ydata_noise,'o', 'Color', 'Red');
fittedModel = plot(times,fun(x,times),'b-');
legend([inputData, inputData_noise,  fittedModel], 'Model', 'Model with Noise', 'Fitted exponential');
title('Data and Fitted Curve');