function [ root1, root2 ] = roots( a, b, c )
    %Find the root of a quadratic
    root1 = (-b+discriminant(a, b, c))/(2*a);
    root2 = (-b-discriminant(a, b, c))/(2*a);
end

function [ discrim ] = discriminant(a, b, c)
    %find the discriminant of quadradtic equation
    discrim = sqrt(b^2-4*a*c);
end

