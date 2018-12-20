%   Function - eigStuff
%   Parameters: 
%       faceMatNorm - A mxn normalized matrix of faces represented as column vectors.
%   Returns:
%       eigVec      - The U component in SVD for faceMatnorm.
%       sigma       - A matrix of singular values for faceMatnorm.
%       faceDist    - A matrix of the projections of each face vector onto 
%                     the k columns of U that are kept.
function [eigVec, sigma, faceDist] = eigStuff(faceMatNorm)
    % This is the number of columns of U that are being kept based on the singular values.
    global numEig;

    % Calculate SVD of a matrix of faces. 
    % S is the matrix of singular values, and U
    % and V are orthonormal matrices.
    % V was never used in the program and is replaced by the ~ symbol. 
    [U, S, ~] = svd(faceMatNorm);
    
%     eigVec = U;
%     sigma = S;

    % Create a column vector of the singular values.
    singular_vals = diag(S);
    % Number of singular values.
%     singular_vals_n = size(singular_vals);
    % k number of columns that will be kept.
    k = 27;
%     % Iterate through the singular values and remove the un-needed ones.
%     for i = 1:singular_vals_n
%         if singular_vals(i) < 2000
%             break
%         end
%         k = k + 1;
%     end

    numEig = k;
    eigVec = U(:,1:k);
    sigma = diag(singular_vals(1:k));
    
    rc = size(faceMatNorm);              % Row vector for size of faceDist matrix.
    faceDist = zeros(numEig, rc(2));     % Value for numEig needs to be calculated.
    
    % Loop over each column of faceDist.
    for i = 1:rc(2)
        % Calculate eigenface representation for each face. The value for
        % U's rows should be calculated, as 50 is arbitrary.
        faceDist(:,i) = U(:,1:numEig)'*faceMatNorm(:,i);
    end
end

