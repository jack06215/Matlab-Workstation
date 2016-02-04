%% Generate the synthetic data from the curve function with some additional noise
x1 = 100;
x2 = 102;
xdata = [0:0.1:15];    % Sampling range and frequency
ydata = x1 * sin(x2 * xdata) + x2 * cos(x1 * xdata);
 
fun = @(x,xdata)x(1)* sin(x(2) * xdata) + x(2) * cos(x(1) * xdata) ;
x0 = [100.5,102.5];
options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt', 'Display', 'iter');
lb = [];
ub = [];
x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options);
times = linspace(xdata(1),xdata(end));
figure, hold on;
plot(xdata,ydata,'ko');
plot(times,fun(x,times),'b-');
legend('Data','Fitted exponential');
title('Data and Fitted Curve');