function meanStdPlotter(input, depths, color)
    len = length(input);
    xVals = cell2mat(depths);
    meanVals = [];
    stdVals = [];
    for i = 1:len
        meanVals = [meanVals input{i}(1)];
        stdVals = [stdVals input{i}(2)];
    end
    plot(xVals, meanVals, 'Color', color, 'LineWidth', 1.5)
    hold on
    for i = 1:length(xVals)
        plot([xVals(i) xVals(i)], [meanVals(i)+stdVals(i) meanVals(i)-stdVals(i)], 'Color', color, 'Marker', '_', 'LineWidth', 1.0);
        hold on
    end
    title(strcat('Mean 12-hr Avg Speed vs Depth: '));
    xlabel('Depth (m)')
    ylabel('12-hr Avg Speed (m/s)')
    xlim([-5 105])
    ylim([0 1]) 
end
