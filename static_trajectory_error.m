%varargin = {struc, flag, drifterNum)
%Struc is the dataset we're pulling from, flag is whether we want to plot
%all trajectories at once or a specific subset of them. If just subset, then drifterNum are the
%ones we want to plot.

%Add reference markers
function static_trajectory_error(struc, drifter, flag)
    
    if flag == 0
       
        indices = find(struc(drifter).qc_flag ~= 1);
        geoplot(struc(drifter).lat(indices), struc(drifter).lon(indices), 'Color', 'r', 'Marker', '.');

        
    elseif flag == 45

        indices = find(struc(drifter).qc_flag == 4 | struc(drifter).qc_flag == 5);
        geoplot(struc(drifter).lat(indices), struc(drifter).lon(indices), '*');

  
    
    
    elseif flag == 12
       
        indices = find(struc(drifter).qc_flag == 11 | struc(drifter).qc_flag == 12);
        geoplot(struc(drifter).lat(indices), struc(drifter).lon(indices), '*');


    end
    
end
        