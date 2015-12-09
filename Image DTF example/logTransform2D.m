function [ output_array_2d ] = logTransform2D( input_array_2d, c )
    output_array_2d = zeros(size(input_array_2d));
    [M,N] = size(input_array_2d);
    for x = 1:M
        for y = 1:N
            m = double(input_array_2d(x,y));
            output_array_2d(x,y) = c .* log10(1+m);
        end
    end
end