function map = ismap(axis)

%*********************************************************************
%  map = ISMAP(axis)
%*********************************************************************
%  Function to determine whether the current axes uses a map 
%  projection from the m_map package
%*********************************************************************
%  axis : axis handle [default = gca]
%  map  : [output] logical flag
%
%          TRUE = axes contain an m_map projection
%         FALSE = axes do not contain an m_map projection
% 
%*********************************************************************

default('axis',gca)

map = logical(max([0 abs(getappdata(axis,'is_map'))])) ;
