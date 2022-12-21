function r = range(a)

%*********************************************************************
%  Function to find the min and max of array or cell array a
%*********************************************************************

if iscell(a)
  b = cell2mat(shiftdim(a)) ;
  r = [min(b(:)),max(b(:))] ;
else
  r = [min(a(:)),max(a(:))] ;
end



