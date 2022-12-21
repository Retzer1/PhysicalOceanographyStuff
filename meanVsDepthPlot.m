function [meanVals, stdVals] = meanVsDepthPlot(strucInput, depthInput, colorInput, flowFeature) %colorInput has strings for colors corresponding to strucs in strucInput
    numberOfStrucs = length(strucInput); 
    
    speedMatrices = {};
    for i = 1:numberOfStrucs
        speedMatrices{i} = twelve_avgspeed_matrix(strucInput{i});
    end
    
    MEANS = {};
    for i = 1:numberOfStrucs
        MEANS{i} = mean(speedMatrices{i}(speedMatrices{i}>0));
    end
    
    STDS = {};
    for i = 1:numberOfStrucs
        STDS{i} = std(speedMatrices{i}(speedMatrices{i}>0));
    end
    
    %SET UP VECTORS FOR PLOTTING
    xVals = cell2mat(depthInput);
    meanVals = cell2mat(MEANS);
    stdVals = cell2mat(STDS);
    
    %PLOT MEANS
    %a = figure; %Take/comment this out if you want to plot more than one year, basically. Because hold is on it will work.
    hold on
    plot(xVals, meanVals, 'Color', colorInput, 'LineWidth', 1.5)
    hold on
    %PLOT STDS
    for i = 1:length(xVals)
        plot([xVals(i) xVals(i)], [meanVals(i)+stdVals(i) meanVals(i)-stdVals(i)], 'Color', colorInput, 'Marker', '_', 'LineWidth', 1.0);
        hold on
    end
        %plot(xVals, meanVals + stdVals, 'Color', colorInput, 'Marker', '_', 'LineWidth', 1.0)
    %hold on
    %plot(xVals, meanVals - stdVals, 'Color', colorInput, 'Marker', '_', 'LineWidth', 1.0)
    %hold on
     
    %CUSTOMIZE APPEARANCE
    title(strcat('Mean 12-hr Avg Speed vs Depth: ', flowFeature));
    xlabel('Depth (m)')
    ylabel('12-hr Avg Speed (m/s)')
    xlim([-5 105])
    ylim([0 1])
end



