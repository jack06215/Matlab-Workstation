%% Find the analytic form of the Jacobianof one row of d w.r.t. the patemeter a and b
close all;
% Create some 'real number' symbolic variables
syms a b x y real;
% A standard f(x) = Ax+B, which we will use this in our example
f = a * sin(b * x) + b * cos(a * x);
% Cost function to be minimised
func_cost = (y - f);
% Defined a Jacobian matrix w.r.t. parameter 'a' and 'b'
Jsym = jacobian(func_cost, [a,b]);
%% Generate the synthetic data from the curve function with some additional noise
a = 100;
b = 102;
x = [0:0.1:15]';    % Sampling range and frequency
y = a * sin(b * x) + b * cos(a * x);

%% Add random noise
y_input = y + 5 * rand(length(x),1); 

%% LM algorithm starts from here, to carry out minimisation it requires 3 things,
% 1. function to be minimise
% 2. Goal vector of observed value of the function
% 3. Initial guess p = {p0, p1, ..., pn}

% initial guess for the parameters
a0 = 100.4; 
b0 = 102.4; 

Ndata = length(y_input);

Nparams = 2; % 2 parameters to be estimated
n_iters = 100; % # of iterations for the LM

a_est = a0;
b_est = b0;
lamda = 0;


for it = 1:n_iters
    % Evaluate the distance error at the current parameters
    y_est = (a_est * sin(b_est * x) + b_est * cos(a_est * x));

    % Evaluate the Jacobian matrix at the current parameters (a_est, b_est)
    J = zeros(Ndata,Nparams);
    for i=1:length(x)
        J(i,1) = b_est*x(i)*sin(a_est*x(i)) - sin(b_est*x(i));
        J(i,2) = -cos(a_est*x(i)) - a_est*x(i)*cos(b*x(i));
    end
    d = y_input - y_est;
    
    % Compute the approximated Hessian matrix, J’ is the transpose of J
    H = J' * J;
    % Apply the damping factor to the Hessian matrix
    H_lm = H + (lamda * eye(Nparams, Nparams));
    e = dot(d,d);
    % Compute the updated parameters
    dp = H_lm \ (J' * d);
    a_est = a_est - dp(1);
    b_est = b_est - dp(2);
    
disp(['Total error: ', num2str(e)]);
end 

figure, hold on;
plot(y, 'Color', 'Black', 'LineWidth', 2);
plot(y_input, '-.b', 'Color', 'Green');
plot(y_est, '-.b', 'Color', 'Red');