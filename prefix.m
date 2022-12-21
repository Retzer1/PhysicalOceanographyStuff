function p = prefix(s)

%*********************************************************************
%  Function to find the prefix in an input filename
%*********************************************************************

a = strfind(s,'.') ;

if ~isempty(a)
  p = s(1:a(end)-1) ; 
else
  p = s ;
end
