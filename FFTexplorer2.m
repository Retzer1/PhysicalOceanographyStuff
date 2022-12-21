function output = FFTexplorer2(struc)
    output = 1;
    cont = 1;
    while cont == 1
        %Get triplet
        drifter1 = input('Drifter 1: ');
        drifter2 = input('Drifter 2: ');
        drifter3 = input('Drifter3: ');
        
        %Plot triplet
        [a, divs] = singleDivergence(struc, drifter1, drifter2, drifter3, 0.2);
        plot(divs);
        pause;
        
        %User selects a range to perform FFT
        mini = input('min');
        maxi = input('max');
        divsData = divs(mini:maxi);
        numDataPts = maxi - mini + 1;
        
        %Perform Fourier Transform
        dataFFT = abs(fft(divsData));
        dataFFT = dataFFT(1:numDataPts/2 + 1); %Remove duplicate/negative side of spectrum

        %Normalize
        dataFFT = dataFFT/numDataPts;
        
        %Create frequency axis (cycles per 5 min, but multiplying by 288 to
        %convert to cycles per day)
        f = 288*(0:numDataPts/2)/numDataPts;
        
        %Plot FFT
        figure
        plot(f, dataFFT)
        xlabel('Frequency, Cycles per day')
        ylabel('Amplitude')
        title(strcat(num2str(drifter1), char(160), num2str(drifter2), char(160), num2str(drifter3))); %Label the triplet
        
        %Continue program?
        cont = input('FFTexplorer: 1 for more, 0 for stop program');
    end
end