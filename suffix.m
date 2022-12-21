function s = suffix(filen)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function to find the file extension of an input filename
%   
%   filen   -- string of filename
%
%   s       -- suffix
%
% Written by Helga Huntley, May 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% s = suffix(filen)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = strfind(filen,'.');

if ~isempty(a)
  s = filen(a(end)+1:end); 
else
  s = [];
end


