function [x,y,lon0,lat0] = ll_to_xy(lon,lat,lon0,lat0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function to get x,y positions corresponding to lon/lat positions.  The
% location with lowest lon is used to define the origin.  Units are meters.
%
%   lon,lat     -- lat/lon positions given as input
%   x,y         -- output of (relative) position vectors in m
%   lon0,lat0   -- reference lon and lat for the origin (optional input)
%
% Written by Helga Huntley, Oct 10, 2007
% Edited Oct 17, 2007 to preserve total distances
% Edited July 2009 to allow input reference lon/lat
% Edit March 2011 to transfer NaNs from lon/lat to x/y
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [x,y,lon0,lat0] = ll_to_xy(lon,lat,lon0,lat0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

default('lon0',[])
default('lat0',[])

%-------------------------------------------------------------------------
% Setting reference lon/lat
%-------------------------------------------------------------------------

if isempty(lon0) || isnan(lon0)
    [lon0,ent] = min(lon(:));      % Reference longitude => x = 0
    lat0 = lat(ent(1));            % Reference latitude  => y = 0
end

%-------------------------------------------------------------------------
% Finding y positions
%-------------------------------------------------------------------------

lon1 = repmat(lon0,size(lon));
lat1 = repmat(lat0,size(lat));

y1 = m_idist(lon1,lat1,lon1,lat);
y1(isnan(y1)) = 0;               % Need to reset y1 from NaN to 0
y = y1.*(lat>lat0) - y1.*(lat<lat0);

%-------------------------------------------------------------------------
% Finding x positions by determining total distance and using the
% Pythagorean Theorem in the plane
%-------------------------------------------------------------------------

tot = m_idist(lon1,lat1,lon,lat);
tot(isnan(tot)) = 0;             % Need to reset tot from NaN to 0
x1 = sqrt(tot.^2 - y.^2);
x = x1.*(lon>lon0) - x1.*(lon<lon0);

%-------------------------------------------------------------------------
% Replacing necessary NaNs
%-------------------------------------------------------------------------

pts = find(isnan(lon));
x(pts) = NaN;
y(pts) = NaN;
