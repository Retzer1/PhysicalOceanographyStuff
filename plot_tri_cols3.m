function h = plot_tri_cols3(struc, tri,P,COLORS,colorLimits, date)

%*************************************************************************
% h = PLOT_TRI_COLS(tri,P,V)
%*************************************************************************
%  Function to plot a triangulation with specific uniform colors for each
%  triangle.  The colors are indexed from the colormap according to the
%  supplied values.
%*************************************************************************
%
%  tri      : Ntri x 3 matrix specifying the connections 
%             (e.g. as created by delaunay.m or DT.ConnectivityList from
%             delaunayTriangulation.m)
%  P        : Npt x 2 matrix specifying the point locations
%             (e.g. as given in DT.Points from delaunayTriangulation.m)
%  V        : Ntri x 1 vector of values associated with each triangle
% 
%  h        ; [output] graphics handle
%
%*************************************************************************
%  Written by Helga Huntley, November 2017
%*************************************************************************
clf
cmocean('balance')
    
      %xy_static_trajectory(1, struc([4 8 9]), 1) %-- For triplet 894 
    %with
    %context
    % xy_static_trajectory(1, struc([4 7 9]), 1) %-- For triplet 794 with
    %context
    xy_static_trajectory(1, struc([1 2 5]), 1) %-- For triplet 251 with
    %context
    
    %xlim([2 3]);
   % ylim([39.5 40.5]);
    hold on
    h = patch('Faces', tri, 'Vertices', P, 'FaceVertexCData', COLORS, 'FaceColor', 'flat');
    colorbar;
    cmocean('balance')
    caxis(colorLimits);
    title(num2str(date));
%     dateB = datevec(date);
%     year = num2str(dateB(1));
%     month = num2str(dateB(2));
%     day = num2str(dateB(3));
%     hour = num2str(dateB(4));
%     title(strcat(year, char(160), month, char(160), day, char(160), hour))
    % for i = 1:numberOfTriangles
%     h = patch('Faces',tri(i, :),'Vertices',P,'FaceColor',COLORS(i, :));
%     hold on
% end

if nargout == 0
    clear h
end
