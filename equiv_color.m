function c = equiv_color(a,data_range,color_range,cmap,out_form)

%*********************************************************************
%  c = EQUIV_COLOR(a,data_range,color_range,cmap,out_form)
%*********************************************************************
%  Function to return equivalent (r,g,b) colors for a data array
%  scaled to a specified colormap.  Where a is NaN, colors are set 
%  to NaN.
%*********************************************************************
%  a           : scalar array (any shape)
%  data_range  : range of data values for color scale limits
%                [default = [min(a(:)),max(a(:))]
%  color_range : range of colormap values to be used, expressed as
%                percent of numel(cmap) (default = [0 1])
%  cmap        : colormap [default: current figure colormap]
%  out_form    : desired format for output
%
%                  1 = c is an array with shape [size(a) 3] [default]
%                  2 = c is a cell array with shape [numel(a) 1]
%
%  c           : [out] output array of (r,g,b) colors
%*********************************************************************

default('data_range',range(a)) ;
default('color_range',[0 1])
default('cmap',[])
default('out_form',1)

if isempty(cmap) ; cmap = get(gcf,'ColorMap') ; end

c = NaN(length(a(:)),3) ;

if ~isreal(a) ; a = abs(a) ; end

valid = find(~isnan(a)) ;

if span(data_range) > 0
    fract = (a(valid)-data_range(1))/span(data_range) ;
else
    fract = zeros(size(a(valid))) ;
end

cr = 1+fix((size(cmap,1)-1)*color_range) ;
Nc = cr(2)-cr(1)+1 ;

index = cr(1)+fix(fract*Nc) ;

index(index > cr(2)) = cr(2) ;
index(index < cr(1)) = cr(1) ;

c(valid,:) = cmap(index,:) ;

switch out_form
    case 1 ; if length(a) > 1; c = squeeze(reshape(c,[size(a) 3])); end
    case 2 ; c = num2cell(c,2) ;
end
