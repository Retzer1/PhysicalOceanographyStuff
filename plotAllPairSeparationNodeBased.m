function listMatrix = plotAllPairSeparationNodeBased(struc1, struc2, areEqual, titleName) %initDist has been replaced by 1000, as initDist does not matter if nodes are same

%Output list matrix of separation vectors

if areEqual == 0
    hold on
    len1 = min(length(struc1), length(struc2)); %This is always 9, (unless it's not, in the case of CODE)
    listMatrix = NaN(5000, len1);
    for i = 1:len1
        
            
        [a, outputData] = singlePairSeparation(struc1, struc2, i, i, 1000);
        outputLen = length(outputData);
        listMatrix(1:outputLen, i) = outputData; %Store separation vector in a column of listMatrix
        
    end
end
if areEqual == 1 %NOTE: DO NOT USE same-depth pair separation for code, there are only 2 pairs that match our criteria, so just plot them singly and store the separation vectors manually using singlePairSeparation. This restriction allows us to simplify the listMatrix definition below.
    hold on
    len = length(struc1);
    indicatorMatrix = [0 1 0 0 1 1 0 0 0; 1 0 1 1 1 1 0 0 0; 0 1 0 1 1 0 0 0 0; 0 1 1 0 1 0 0 1 1; 1 1 1 1 0 1 1 1 1; 1 1 0 0 1 0 1 1 0; 0 0 0 0 1 1 0 1 0; 0 0 0 1 1 1 1 0 1; 0 0 0 1 1 0 0 1 0]; %Indicates which same-depth pairs we want
    indicatorMatrix = triu(indicatorMatrix); %Eliminate duplicates
    counter = 0;
    listMatrix = NaN(5000, 20); %Because for all except CODE, there are 20 same-depth pairs
    for i = 1:len
        for j = 1:len
            if indicatorMatrix(i, j) == 1
                counter = counter + 1;
                [a, outputData] = singlePairSeparation(struc1, struc2, i, j, 1000);
                outputLen = length(outputData);
                listMatrix(1:outputLen, counter) = outputData; %Store separation vector in appropriate column of listMatrix
            end
        end
    end
end
%APPEARANCE CUSTOMIZATION---------------
xlim([0 4500])
ylim([0 100])
xlabel('Number of 5-min intervals')
ylabel('Kilometers')
title(titleName)
end
    