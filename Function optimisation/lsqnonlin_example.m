close all; clear, clc;
rng default;    % Setup random number generator
% Reference for more info:
%       lsqnonlin --> http://au.mathworks.com/help/optim/ug/lsqnonlin.html
%       Passing Extra Parameters --> http://au.mathworks.com/help/optim/ug/passing-extra-parameters.html
% Create data point with some noise
d = linspace(0,3);
y = exp(-1.3*d) + 0.05*randn(size(d));  % Here 1.3 is our real solution, we add some noise to it
% Start with any initial guess 
x0 = 4;
% Create a structure of configuration for optimisation
options = optimset('Algorithm','levenberg-marquardt',...
                 'Display', 'iter',... 
                 'MaxIter', 100,... 
                 'TolFun', 10^-20,... 
                 'TolX', 10^-10,... 
                 'MaxFunEvals',10^20,...
                 'LargeScale', 'off');
% Create anon function allow us to pass extra parameters to the cost function
f = @(x0)objectivecost(x0,d,y);
% Function call to MATLAB optimisation tool
[x, fval] = lsqnonlin(f,x0,[],[],options);
% Plot the result
plot(d,y,'ko',d,exp(-x*d),'b-');
legend('Data','Best fit');
xlabel('t');
ylabel('exp(-tx)');
