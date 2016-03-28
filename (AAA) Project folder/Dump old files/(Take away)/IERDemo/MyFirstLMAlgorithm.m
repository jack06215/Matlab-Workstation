% %% Find the analytic form of the Jacobianof one row of d w.r.t. the patemeter a and b
% syms fx foc i_hat j_hat theta_est phi_est real;
% fx_top = foc * j_hat * cos(phi_est) + foc * sin(phi_est);
% fx_bottom = (j_hat * sin(phi_est) + cos(phi_est)) * cos(theta_est) - i_hat * sin(theta_est);
% h =  ((fx_top) / (fx_bottom));
% d = fx - h;
% Jsym = jacobian(d, [theta_est,phi_est]);


% --------------------------


%% Find the analytic form of the Jacobianof one row of d w.r.t. the patemeter a and b
close all;
syms a b x y real;
f = (a * cos(b * x) + b * sin(a * x));
de = (y - f)^2;
Jsym = jacobian(de, [a,b]);

%% Generate the synthetic data from the curve function with some additional noise
a = 100;
b = 102;
x = [0:0.1:2*pi]';
y = a * cos(b * x) + b * sin(a * x);

%% Add random noise
y_input = y + 5 * rand(length(x),1); 

%% LM algorithm starts from here, to carry out minimisation it requires 3 things,
% 1. function to be minimise
% 2. Goal vector of observed value of the function
% 3. Initial guess p = {p0, p1, ..., pn}

% initial guess for the parameters
a0 = 97.3; 
b0 = 95.3; 

y_init = a0 * cos(b0*x) + b0 * sin(a0*x);
Ndata = length(y_input);

Nparams = 2; % a and b are the parameters to be estimated
n_iters = 3; % set # of iterations for the LM
lamda = 0; % set an initial value of the damping factor for the LM

updateJ = 1;
a_est = a0;
b_est = b0;



for it = 1:n_iters
    %if (updateJ == 1)
        % Evaluate the distance error at the current parameters
        y_est = a_est * cos(b_est*x) + b_est * sin(a_est*x);
        
        % Evaluate the Jacobian matrix at the current parameters (a_est, b_est)
        J = zeros(Ndata,Nparams);
        for i=1:length(x)
            % J(i,1) = (cos(b_est*x(i)) + b_est*x(i)*cos(a_est*x(i)))*(a_est*cos(b_est*x(i)) - y_est(i) + b_est*sin(a_est*x(i)));
            % J(i,1)
            %J(i,2) = (sin(a_est*x(i)) - a_est*x(i)*sin(b_est*x(i)))*(a_est*cos(b_est*x(i)) - y_est(i) + b_est*sin(a_est*x(i)));    
             J(i,1)= -cos(b_est * x(i)) - (b_est * cos(a_est * x(i)) * x(i));
             J(i,2) = (a_est * sin(b_est * x(i)) * x(i)) - sin(a_est * x(i));
        end
        d = y_input - y_est;
        
        % Compute the approximated Hessian matrix, J’ is the transpose of J
        H = J' * J;
        %if (it == 1) % the first iteration : compute the total error
            e = dot(d,d);
        %end
     % end
    
    % Apply the damping factor to the Hessian matrix
    H_lm = H + (lamda * eye(Nparams, Nparams));

    % Compute the updated parameters
    dp = H_lm \ (J' * d);
    a_est = a_est - dp(1);
    b_est = b_est - dp(2);
    disp(['e: ', num2str(e)]);
%     % Evaluate the total distance error at the updated parameters
%     y_est_lm = a_lm * cos(b_lm*x) + b_lm * sin(a_lm*x);
%     d_lm = y_input - y_est_lm;
%     e_lm = 0.5 * dot(d_lm, d_lm);
%     disp(['e: ', num2str(e), ' AND e_lm: ', num2str(e_lm)]);
%     % If the total distance error of the updated parameters is less than the previous one
%     % then makes the updated parameters to be the current parameters
%     % and decreases the value of the damping factor
%     if e_lm < e
%         lamda = lamda / 10;
%         a_est = a_lm;
%         b_est = b_lm;
%         e = e_lm;
%         disp('update parameters');
%         updateJ = 1;
%     else % otherwise increases the value of the damping factor
%         updateJ = 0;
%         lamda = lamda * 10;
%         % disp('did not update parameters')
%     end
end 

figure, hold on;
plot(y, 'Color', 'Black', 'LineWidth', 2);
plot(y_input, '-.b', 'Color', 'Green');
plot(y_est, '-.b', 'Color', 'Red');