function animateStructure(struc, numFrames, fps, filename)
    datenums = find_datenum(struc);
    len = length(datenums);
    iterationSize = fix(len / numFrames); %How many indices apart will successive frames be?
    %Might want to verify ^^ is not zero
    for i = 0:numFrames-1
        plotAllBefore(struc, datenums(1 + (i*iterationSize)))
        
        dateB = (datevec(datenums(1 + (i*iterationSize))));
        year = num2str(dateB(1));
        month = num2str(dateB(2));
        day = num2str(dateB(3));
        hour = num2str(dateB(4));
        title(strcat(year, char(160), month, char(160), day, char(160), hour));
        save_frame(i+1,numFrames, fps, filename);
    end
end
        
        