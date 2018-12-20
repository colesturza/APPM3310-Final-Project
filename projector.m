function [y] = projector(U,face)
    global numEig;
    y = U(:,1:numEig)'*face;
end
