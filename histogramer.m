function output = histogramer(datamatrix, filename, plotname, bin_width, limit)
    %Data matrix is of the following form: Rows correspond to drifter #s,
    %and the data is stored in row vectors, where entry (i, j) is the j-th
    %data point for the i-th drifter. Note that, when not all drifters have
    %the same # of data points, drifters with shorter data series may have
    %many 0's at the end of their row. 
    
    atleast = datamatrix > 0; %We want to exclude NaN or zero-length 
    if limit == 0
        Upperlimit = max(datamatrix, [], 'all') + bin_width;
        edges = 0:bin_width:Upperlimit; 
    end
    if limit > 0 %User specified an upper limit for the biggest value
        Upperlimit = limit;
        edges = 0:bin_width:Upperlimit;
    end
    
    %Normalization is for probability
    histogram(datamatrix(atleast), edges, 'Normalization', 'Probability') %histogram(arclengthmatrix(atleast), edges)
  %  xlabel('Kilometers')
  %  ylabel('Frequency')
    xlabel('Meters Per Second')
    ylabel('Relative Frequency')
    title(plotname)
    ylim([0 1]) %For probability
    %xlim([0 Upperlimit]);
    fsave('png', filename);
    output = gcf(); %Outputs the figure object if needed for further use
end