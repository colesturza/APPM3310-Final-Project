function [matrix,avg] = separate(matrix_in)

[~, c] = size(matrix_in);

avg = zeros(10000,1);
matrix = zeros(10000, c);

%find average of all column vecors in matrix
for i = 1:10000
    avg(i) = mean(matrix_in(i,:)); 
end

%calculate matrix containing the elements of each vector that differs from
%average of column vectors
for i = 1:10000
    for j = 1:c
        matrix(i,j) = matrix_in(i,j) - avg(i);
    end
end

end

