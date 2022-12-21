function wasPlottedList = plotAllPairSeparation(struc1, struc2, initDist, areEqual) %Can output a list of pairs that were actually plotted
wasPlottedList = zeros(length(struc1), length(struc2));
if areEqual == 0
    hold on
    len1 = length(struc1);
    len2 = length(struc2);
    for i = 1:len1
        for j = 1:len2
            
            wasPlotted = singlePairSeparation(struc1, struc2, i, j, initDist);
            if wasPlotted
                wasPlottedList(i, j) = 1;
            end
        end
    end
end
if areEqual == 1
    hold on
    len = length(struc1);
    flagMat = ones(len, len);
    flagMat = triu(flagMat) - diag(diag(flagMat)); %Matrix of ones ABOVE main diagonal
    for i = 1:len
        for j = 1:len
            if flagMat(i, j) == 1
                wasPlotted = singlePairSeparation(struc1, struc2, i, j, initDist);
                if wasPlotted
                    wasPlottedList(i, j) = 1;
                end
            end
        end
    end
end
%APPEARANCE CUSTOMIZATION---------------
xlim([0 4500])
ylim([0 60])
xlabel('5 minute intervals')
ylabel('km')
title('WHOI 35m/50m, initial separation <= 0.5km')
end
    