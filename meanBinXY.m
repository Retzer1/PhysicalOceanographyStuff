function meanBinXY(xData, yData, minValue, barWidth, numBars, plotName)
    %Input one-dimensional xData and yData, a minimum of min bin, width of
    %each bin/bar, and number of bins/bars, along with string plotName
    
    %XDATA is binned, and then YDATA is summarized according to those bins
    
    bins = minValue:barWidth:(minValue + numBars*barWidth);
    barCenters = (minValue+barWidth/2):barWidth:(minValue + numBars*barWidth - barWidth/2);
    
    groupXData = discretize(xData, bins); %Group X data into bins
    UniqueGroupXData = unique(groupXData); %Find which bins are, in fact, used. There will be as many entries in this vector as there are unique groups in above line's vector, this is useful for plotting
    
    meansYData = groupsummary(yData, groupXData, "mean"); %Bin each Y datapoint into its corresponding x-value's bin, take mean of each of these bins
    %Note: UniqueGroupXData and meansYDATA both have as many entries as
    %there are unique groups in groupXData
    figure
    bar(barCenters(UniqueGroupXData), meansYData)
    title(plotName)
    xlim([minvalue maxValue])
end