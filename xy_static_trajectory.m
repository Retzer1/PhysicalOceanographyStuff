%varargin = {struc, flag, drifterNum)
%Struc is the dataset we're pulling from, flag is whether we want to plot
%all trajectories at once or a specific subset of them. If just subset, then drifterNum are the
%ones we want to plot.

%Add reference markers
function xy_static_trajectory(marker, varargin)
    struc = varargin{1};
    len = length(struc);
    if nargin == 3 && marker == 0 %We want to plot them all, with markers
        for i = 1:len
            plot(struc(i).lon, struc(i).lat, '.')
            hold on
        end
    end
    
    if nargin == 3 && marker == 1 %We want to plot them all, lines
        for i = 1:len
            plot(struc(i).lon, struc(i).lat, 'Color', 'g', 'LineWidth', 0.0001)
            hold on
        end
    end
    
    if nargin == 4 && marker == 0 %We want to plot a selection of them, with marker
        drifterNum = varargin{3}; 
        for i = 1:length(drifterNum)
            plot(struc(drifterNum(i)).lon, struc(drifterNum(i)).lat, '.')
            hold on
        end
    end
    if nargin == 4 && marker == 1 %We want to plot a selection of them, with line
        drifterNum = varargin{3}; 
        for i = 1:length(drifterNum)
            plot(struc(drifterNum(i)).lon, struc(drifterNum(i)).lat)
            hold on
        end
    end
    
end
        