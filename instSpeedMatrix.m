function output = instSpeedMatrix(struc)
    len = length(struc);
    totalVector = [];
    for i = 1:len
        totalVector = cat(1, totalVector, find_speed_vector(struc, i));
    end
    output = totalVector;
end
    