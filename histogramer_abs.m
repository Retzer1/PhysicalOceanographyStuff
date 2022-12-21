function output = histogramer_abs(datamatrix, filename, plotname, bin_width, limit, xlab, ylab)
    %Data matrix is of the following form: Rows correspond to drifter #s,
    %and the data is stored in row vectors, where entry (i, j) is the j-th
    %data point for the i-th drifter. Note that, when not all drifters have
    %the same # of data points, drifters with shorter data series may have
    %many 0's at the end of their row. Bin_width must go into 1 evenly
    %(0.2, 0.1, etc, but not 0.16). 
    
    notNaN = ~(isnan(datamatrix));
    if size(limit, 2) == 0
        Upperlimit = ceil(max(max(max(datamatrix)))+ bin_width);
        Lowerlimit = min([0 floor(min(min(min(datamatrix))) - bin_width)]);
        edges = Lowerlimit:bin_width:Upperlimit; 
    end
    if size(limit, 2) ~= 0 %User specified an upper limit for the biggest value
        Upperlimit = limit(2);
        Lowerlimit = limit(1);
        edges = Lowerlimit:bin_width:Upperlimit;
    end
    
    %Normalization is for probability
    histogram(datamatrix(notNaN), edges, 'Normalization', 'Probability') %histogram(arclengthmatrix(atleast), edges)
  %  xlabel('Kilometers')
  %  ylabel('Frequency')
    xlabel(xlab)
    ylabel(ylab)
    title(plotname)
    ylim([0 1]) %For probability
    fsave('png', filename);
    output = gcf(); %Outputs the figure object if needed for further use
end