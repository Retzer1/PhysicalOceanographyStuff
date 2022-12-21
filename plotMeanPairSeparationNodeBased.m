function plotMeanPairSeparationNodeBased(struc1, struc2, areEqual, titleName) %Init distance not important, 1000 was subbed for it
%Use with WHOI/SPOT/SVP node-based experiment, struc1 and struc2 correspond
%to diff or same depths. We assume struc1(i) is the i-th node drifter,
%struc2(i) is i-th node drifter. Otherwise, sort the structures so it's
%this way first before using this program. Don't use with CODE because too
%few. 
if areEqual == 0
    hold on
    len1 = length(struc1); %This is 9 for 2022 data, as there are 9 nodes
    
    separationMatrix = zeros(length(find_datenum(struc1)), len1); %Stores the separation vectors for individual pairs
    counter = 0; %We use this to fill the columns of our separation matrix, placing successive separation vectors into successive columns of our matrix
    for i = 1:len1
        
        counter = counter+1;
        vec = singlePairSeparationVector(struc1, struc2, i, i, 1000); %Will be at most length(find_datenum(struc1)) in length, possibly less if NaNs are trimmed from start. We use a huge initial distance because we just want the earliest datenum-overlapping pair, regardless of whether its 3km or 1km apart, as long as they are the same node. 
        lenOfCurrentSeparationVector = length(vec);
        separationMatrix(1:lenOfCurrentSeparationVector, counter) = vec; 
        
    end
end
if areEqual == 1
    hold on
    len = length(struc1);
    separationMatrix = zeros(length(find_datenum(struc1)), 20); %Stores the separation vectors for individual same-depth pairs, we know we have 20 of these for 2022 data
    
    indicatorMatrix = [0 1 0 0 1 1 0 0 0; 1 0 1 1 1 1 0 0 0; 0 1 0 1 1 0 0 0 0; 0 1 1 0 1 0 0 1 1; 1 1 1 1 0 1 1 1 1; 1 1 0 0 1 0 1 1 0; 0 0 0 0 1 1 0 1 0; 0 0 0 1 1 1 1 0 1; 0 0 0 1 1 0 0 1 0]; %Indicates which same-depth pairs we want
    indicatorMatrix = triu(indicatorMatrix); %Eliminate duplicates
    counter = 0;
    for i = 1:len
        for j = 1:len
            if indicatorMatrix(i, j) == 1 %Make sure drifters are a pair we actually want to include
                counter = counter+1;
                vec = singlePairSeparationVector(struc1, struc2, i, j, 1000); %Will be at most length(find_datenum(struc1)) in length, possibly less if NaNs are trimmed from start
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
plot(meanVector + 2*standevVector)
plot(meanVector - 2*standevVector)
%The way this is being done, the most data is at the start, no new pairs
%appear after the start

%Tweak as necessary-------------------------------------------------
xlim([0 4500]); 
ylim([0 100]);
xlabel('Number of 5-min intervals'); 
ylabel('km');
title(titleName);
end