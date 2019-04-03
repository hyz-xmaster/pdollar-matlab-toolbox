function [X] = unormalize_data(X, mean_X, std_X)

  X = (X .* repmat(std_X, size(X,1), 1)) + repmat(mean_X, size(X,1), 1);

end