function [c, ceq] = coast_time(x)
% hi
f = x(1);
t = x(2);

c(1) = t - 1 * 1.23 / f / t;
c(2) = 0;
ceq  = double([]);
end

