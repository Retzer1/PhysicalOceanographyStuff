function f = my_getframe(h)

%*********************************************************************
%  A more robust getframe that is not impacted when the current
%  plot window is not visible, or is obscured
%*********************************************************************

default('h',gcf)

orig_mode = get(h,'PaperPositionMode') ;

set(h,'PaperPositionMode','auto') ;

drawnow; drawnow;

f = im2frame(print(h,'-RGBImage')) ;

set(h,'PaperPositionMode',orig_mode) ;

