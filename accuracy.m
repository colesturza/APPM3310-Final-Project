function [numEig] = accuracy(acc,sigvals)
%Determines number of Eigenvalues to be within given accuracy percent
error = 1-diag(sigvals)/norm(diag(sigvals));
index = find(error >= acc,1);
numEig = index;
end

