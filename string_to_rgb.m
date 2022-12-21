function rgb = string_to_rgb(string)

%*************************************************************************
%  rgb = STRING_TO_RGB(string)
%*********************************************************************
%  Function to convert a color specified as a string to an RGB triplet
%*********************************************************************
%  string : single color specified as a string with one or more
%           characters. {Examples:  'b' or 'blue'}
%  rgb    : [out] three element vector specifying an RGB triplet
%*********************************************************************
  
rgb = [];

switch string
    case {'y' 'yellow'}  ; rgb = [1 1 0];
    case {'m' 'magenta'} ; rgb = [1 0 1];
    case {'c' 'cyan'}    ; rgb = [0 1 1];
    case {'r' 'red'}     ; rgb = [1 0 0];
    case {'g' 'green'}   ; rgb = [0 1 0];
    case {'b' 'blue'}    ; rgb = [0 0 1];
    case {'w' 'white'}   ; rgb = [1 1 1];
    case {'k' 'black'}   ; rgb = [0 0 0];
end
