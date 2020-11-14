clc, clear
%solves a quadratic

%grabs some input
coefficents = inputdlg({'a:', 'b:', 'c:'});

%converts input to some double floats
a = str2double(coefficents(1));
b = str2double(coefficents(2));
c = str2double(coefficents(3));

%grabs the roots from the functions
[ root1, root2] = roots(a, b, c);

%chucks the roots out to the stdout
fprintf('Root 1 is: %f+%fi \nRoot2 is %f-%fi\n', real(root1), ...
    imag(root1), real(root2), imag(root1))