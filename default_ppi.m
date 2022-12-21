function ppi = default_ppi(type)

%*********************************************************************
%  ppi = DEFAULT_PPI(type)
%*********************************************************************
%  Function to set the default pixels/inch setting for figure tools 
%  such as set_figure.m, resize_text.m, fsave.m, and save_frame.m.
%*********************************************************************
%  Different default values work best for printing/saving and for
%  resizing.  The value of 'type' determines which default value is
%  returned:
%
%  type : 0 = default value for resizing
%         1 = default value for printing/saving
%
%*********************************************************************
%  Written by Helga Huntley, December 2011
%  Edited Jauary 2012 to include input parameter
%*********************************************************************

default('type',1)

switch type
    case 0    ; ppi = 99 ;
    otherwise ; ppi = 72 ;
end
