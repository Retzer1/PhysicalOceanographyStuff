%This function gets all the nonzero entries of an arc-length matrix into a
%single row vector, which it then takes the variance of, and then takes the
%square root of. 
function stddev = standev(arclenmatrix)
s = size(arclenmatrix);
a = [];
    for i = 1:s(1)
        for k = 1:length(arclenmatrix(i, :))
            if arclenmatrix(i, k) ~= 0
                a = [a arclenmatrix(i, k)];
            end
        end
    end
b = var(a);
stddev = sqrt(b)
end