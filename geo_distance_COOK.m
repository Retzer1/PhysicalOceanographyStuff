function [dist,east,north] = geo_distance_COOK(lon1,lat1,lon2,lat2)

%*********************************************************************
%  Function to compute the distance in km between two points on the
%  earth
%*********************************************************************
%  Point 1:  (lon1,lat1)
%  Point 2:  (lon2,lat2)
%*********************************************************************

y_m = 111132.92-559.82.*cosd(2.*lat1)+1.175.*cosd(4.*lat1) ...
      -0.0023.*cosd(6.*lat1) ;

x_m = 111412.84.*cosd(lat1)-93.5.*cosd(3.*lat1) ...
      +0.0118.*cosd(5.*lat1) ;

if nargout > 1
    east  = (lon2-lon1).*x_m/1000 ;
    north = (lat2-lat1).*y_m/1000 ;
    dist  = sqrt(east.^2+north.^2) ;
else
    dist  = sqrt(((lon2-lon1).*x_m/1000).^2+((lat2-lat1).*y_m/1000).^2) ;
end
