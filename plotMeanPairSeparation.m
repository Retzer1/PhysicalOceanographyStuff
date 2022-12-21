function plotMeanPairSeparation(struc1, struc2, initDist, areEqual)

if areEqual == 0
    hold on
    len1 = length(struc1);
    len2 = length(struc2);
    separationMatrix = zeros(length(find_datenum(struc1)), len1*len2); %Stores the separation vectors for individual pairs
    counter = 0; %We use this to fill the columns of our separation matrix, placing successive separation vectors into successive columns of our matrix
    for i = 1:len1
        for j = 1:len2
            counter = counter+1;
            vec = singlePairSeparationVector(struc1, struc2, i, j, initDist); %Will be at most length(find_datenum(struc1)) in length, possibly less if NaNs are trimmed from start
            lenOfCurrentSeparationVector = length(vec);
            separationMatrix(1:lenOfCurrentSeparationVector, counter) = vec; 
        end
    end
end
if areEqual == 1
    hold on
    len = length(struc1);
    separationMatrix = zeros(length(find_datenum(struc1)), len*len - len); %Stores the separation vectors for individual pairs
    flagMat = ones(len, len);
    flagMat = triu(flagMat) - diag(diag(flagMat)); 
    counter = 0;
    for i = 1:len
        for j = 1:len
            if flagMat(i, j) == 1 %Make sure drifters are not same drifter, and we also don't want to repeat pairs that were already matched
                counter = counter+1;
                vec = singlePairSeparationVector(struc1, struc2, i, j, initDist); %Will be at most length(find_datenum(struc1)) in length, possibly less if NaNs are trimmed from start
                lenOfCurrentSeparationVector = length(vec);
                separationMatrix(1:lenOfCurrentSeparationVector, counter) = vec; 
                
            end
        end
    end
    
end
%Separation matrices finished, now calculate means, after converting zeros
%to NaNs
separationMatrix(separationMatrix == 0) = NaN;

meanVector = mean(separationMatrix, 2, 'omitnan');
standevVector = std(separationMatrix, 0, 2, 'omitnan');
plot(meanVector)
plot(meanVector + standevVector)
plot(meanVector - standevVector)
%The way this is being done, the most data is at the start, no new pairs
%appear after the start

%Tweak as necessary-------------------------------------------------
xlim([0 4500]); 
ylim([0 60]);
xlabel('5-minute intervals'); 
ylabel('km');
title('Mean Pair Separation of 8m-50m WHOI drifter pairs, initial separation <= 3km');
end