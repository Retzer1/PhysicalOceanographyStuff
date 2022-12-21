function [separationMatrix, pairIdentifiers, startIndices] = sepPairIndices(struc1, struc2, initDist, areEqual)

if areEqual == 0
    
    len1 = length(struc1);
    len2 = length(struc2);
    separationMatrix = zeros(length(find_datenum(struc1)), len1*len2); %Stores the separation vectors for individual pairs
    pairIdentifiers = zeros(2, len1*len2); %Entry 1, j is the drifter # of the 1st drifter in the pair corresponding to separation vector j in separationMatrix.
    startIndices = zeros(2, len1*len2); %Entry 1, j is the first index at which the 1st drifter in the j-th pair is present at the overlap between the 1st and 2nd drifters of the j-th pair
    
    counter = 0;
    for i = 1:len1
        for j = 1:len2
            counter = counter+1;
            [vec1, vec2] = singlePairSeparationVector2(struc1, struc2, i, j, initDist); %Will be at most length(find_datenum(struc1)) in length, possibly less if NaNs are trimmed from start
            len = length(vec1);
            separationMatrix(1:len, counter) = vec1; 
            pairIdentifiers(1, counter) = i;
            pairIdentifiers(2, counter) = j;
            startIndices(1, counter) = vec2(1);
            startIndices(2, counter) = vec2(2);
        end
    end
end
if areEqual == 1
    
    len = length(struc1);
    separationMatrix = zeros(length(find_datenum(struc1)), len*len - len); %Stores the separation vectors for individual pairs
    pairIdentifiers = zeros(2, len*len - len); %Entry 1, j is the drifter # of the 1st drifter in the pair corresponding to separation vector j in separationMatrix.
    startIndices = zeros(2, len*len - len); %Entry 1, j is the first index at which the 1st drifter in the j-th pair is present at the overlap between the 1st and 2nd drifters of the j-th pair
    flagMat = ones(len, len);
    flagMat = triu(flagMat) - diag(diag(flagMat)); 
    counter = 0;
    for i = 1:len
        for j = 1:len
            if flagMat(i, j) == 1 %Make sure drifters are not same drifter, and we also don't want to repeat pairs that were already matched
                counter = counter+1;
                [vec1, vec2] = singlePairSeparationVector2(struc1, struc2, i, j, initDist); %Will be at most length(find_datenum(struc1)) in length, possibly less if NaNs are trimmed from start
                len3 = length(vec1);
                separationMatrix(1:len3, counter) = vec1; 
                
                pairIdentifiers(1, counter) = i;
                pairIdentifiers(2, counter) = j;
                startIndices(1, counter) = vec2(1);
                startIndices(2, counter) = vec2(2);
                
            end
        end
    end
    
end
%Separation matrices finished, now calculate means, after converting zeros
%to NaNs
separationMatrix(separationMatrix == 0) = NaN;

meanVector = mean(separationMatrix, 2, 'omitnan');
standevVector = std(separationMatrix, 0, 2, 'omitnan');

end