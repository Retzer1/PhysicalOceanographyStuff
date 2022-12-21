function output = FFTplot(struc, drifter1, drifter2, drifter3, index1, index2)
    output = 1;
    [a, divs] = singleDivergence(struc, drifter1, drifter2, drifter3, 0.2);
    divsData = divs(index1:index2);
    numDataPts = index2 - index1 + 1;
    %Perform Fourier Transform
    dataFFT = abs(fft(divsData));
    dataFFT = dataFFT(1:numDataPts/2 + 1); %Remove duplicate/negative side of spectrum

    %Normalize
    dataFFT = dataFFT/numDataPts;
    %Frequency axis (cycles per 5 min, but multiplying by 288 to
    %convert to cycles per day)
    f = 288*(0:numDataPts/2)/numDataPts;
    %Plot
    figure
    plot(f, dataFFT)
    xlabel('Frequency, Cycles per day')
    ylabel('Amplitude')
    title(strcat(num2str(drifter1), char(160), num2str(drifter2), char(160), num2str(drifter3))); %Label the triplet
    
end