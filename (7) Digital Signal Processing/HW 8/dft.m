function out = dft(x_input)
N = length(x_input);

mat = cumsum(ones(N, N)) - 1;
mat = exp(mat .* mat' * -1j * pi * 2 / N);

out = mat * x_input;
end

