function f = coriolis(lat)

%*********************************************************************
%  Function to compute Coriolis for a given latitude
%*********************************************************************

f = 2.*7.2921e-5*sind(lat) ;
