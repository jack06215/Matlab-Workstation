syms f x_i2 y_i2 theta phi
fun = f * x_i2 * cos(theta) * (f * y_i2 * sin(phi) - f * cos(phi)) / -(y_i2 * sin(phi) - cos(phi)) * cos(theta) + x_i2 * sin(theta);
Jsym = jacobian(fun, [theta, phi]);
x_i2 = 199;
y_i2 = 100;
f = 4;
theta = 0.453;
phi = 0.5345;
subs(Jsym);
% syms x
% y = x^2;