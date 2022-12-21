function animateStructureChase(struc, numFrames, fps, filename, X) %Plots X entries at a time
%Datenums are in steps of 0.0035
    datenums = find_datenum(struc);
    len = length(datenums);
    iterationSize = fix(len / numFrames); %How many indices apart will successive frames be?
    %Might want to verify ^^ is not zero
    for i = 0:numFrames-1
        clf
        plotAllBetweenTime(struc, max(datenums(1), datenums(1 + (i*iterationSize))-X*0.0035), datenums(1 + (i*iterationSize)), 0)
    
        dateB = (datevec(datenums(1 + (i*iterationSize))));
        year = num2str(dateB(1));
        month = num2str(dateB(2));
        day = num2str(dateB(3));
        hour = num2str(dateB(4));
        title(strcat(year, char(160), month, char(160), day, char(160), hour));
        save_frame(i+1, numFrames, fps, filename);
    end
end
        
        