function fsave(format,file_prefix,ppi,screen,transparent_color,simple_mode)

%*********************************************************************
%  FSAVE(format,file_prefix,ppi,screen)
%*********************************************************************
%  Function to save the current figure to an image file; retaining
%  displayed tick marks
%*********************************************************************
%  format        : string specifying the image file format.  This can
%                  be any format used by the Matlab print command.
%                
%                  Useful: {'png' 'jpg' 'tif' 'pdf' 'eps' 'epsc'}
% 
%  file_prefix   : string specifying filename prefix
%  ppi           : pixels per inch {default set by default_ppi.m}
%  screen        : print summary to screen? {0=no; 1=yes [default]}
%
%  transparent_color : [PNG only]  Optional color to be set as
%                      'transparent' in the output file
%  simple_mode   : non-zero [default] to use saveas instead of print
%*********************************************************************

global HOME im_convert

default('format','jpg')
default('file_prefix',[HOME 'matlab'])
default('ppi',default_ppi(1))
default('screen',1)
default('transparent_color',[])
default('simple_mode',1)

switch format
    case 'jpg'   ; format = 'jpeg'  ; suffix = 'jpg' ;
    case 'jpeg'  ; suffix = 'jpg'   ;
    case 'tif'   ; format = 'tiff'  ; suffix = 'tif' ;
    case 'tiff'  ; suffix = 'tif'   ;
    case 'tiffn' ; suffix = 'tif'   ;
    case 'eps'   ; format = 'epsc'  ; suffix = 'eps' ;
    case 'epsc'  ; suffix = 'eps'   ;
    otherwise    ; suffix = format ;
end

file = [prefix(file_prefix) '.' suffix];

s_units = get(gcf,'Units') ;
p_units = get(gcf,'PaperUnits') ;
p_pos   = get(gcf,'PaperPosition') ;

set(gcf,'Units','pixels')
set(gcf,'PaperUnits','inches','PaperPosition',get(gcf,'Position')/ppi)

drawnow

%---------------------------------------------------------------------
%  Retain all current tick markers
%---------------------------------------------------------------------

hca = findobj(gcf,'type','axes');
Nax = length(hca);

TickModes = cell(Nax,3);

for n = 1:Nax
    TickModes{n,1} = get(hca(n),'XTickMode');
    TickModes{n,2} = get(hca(n),'YTickMode');
    TickModes{n,3} = get(hca(n),'ZTickMode');
    
    set(hca(n),'XTickMode','manual');
    set(hca(n),'YTickMode','manual');
    set(hca(n),'ZTickMode','manual');
end

%---------------------------------------------------------------------
%  Use print function to create output image file
%---------------------------------------------------------------------

if strcmp(format,'pdf')
    tfile = [HOME 'matlab.tif'] ;

    print('-dtiffn',sprintf('-r%d',ppi),tfile) ;

    system(['convert ' tfile ' ' file]) ;
    system(['rm ' tfile]) ;
else
    if simple_mode
        saveas(gcf,file)
    else
        print('-painters',['-d' format],sprintf('-r%d',ppi),file) ;
    end
end

%---------------------------------------------------------------------
%  Set transparent color if desired [PNG only]
%---------------------------------------------------------------------

if strcmp(format,'png') & ~isempty(transparent_color)
    t_opt = sprintf(' -transparent ''rgb(%d,%d,%d)'' ', ...
                    floor(255*transparent_color)) ;

    s = unix(sprintf('%s %s %s %s',im_convert,file,t_opt, ...
                     sprintf('PNG32:%s',file))) ;
end

%---------------------------------------------------------------------
%  Reset pre-saving settings
%---------------------------------------------------------------------

set(gcf,'Units',s_units,'PaperUnits',p_units,'PaperPosition',p_pos)

for n = 1:Nax
    set(hca(n),'XTickMode',TickModes{n,1});
    set(hca(n),'YTickMode',TickModes{n,2});
    set(hca(n),'ZTickMode',TickModes{n,3});
end

if screen
    fprintf('\n --> Saved figure to %s\n\n',file)
end
