function geoPlotLatLonValue(dataMatrix, max)
    len = size(dataMatrix, 1);
    colorMatrix = zeros(len, 3);
    if max == 0
        rngArray = range(dataMatrix(:, 3));
        %rngArray = abs(rngArray);
    else
        rngArray = [-max max];
    end
    
   % for i = 1:len
    %    colorMatrix(i, :) = equiv_color(abs(dataMatrix(i, 3)), rngArray);
    %end
    
    for i = 1:len/2
        geoplot(dataMatrix(i, 1), dataMatrix(i, 2), 'Marker', '.', 'Color', equiv_color(abs(dataMatrix(i, 3)), rngArray));
        hold on
    end
end