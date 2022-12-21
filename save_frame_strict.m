function save_frame_strict(frame,total_frames,frames_per_second, ...
                           movie_file,frame_directory,strict_colormap)

%********************************************************************
%  SAVE_FRAME_STRICT(frame,total_frames,frames_per_second,movie_file, ...
%                    frame_directory,strict_colormap)
%********************************************************************
%  Function to save a sequence of Matlab figures to individual GIF 
%  frame files and create a single animated GIF from them. The 
%  'strict_colormap' option applies a single 256 color map to all 
%  GIF frames when the final animation is created.
%********************************************************************
%  NOTE: This function uses the ImageMagick 'convert' command. 
%        The global variable 'im_convert' (normally set in startup.m) 
%        must contain the path to this command.  
%********************************************************************
%  frame             : current frame number
%  total_frames      : total number of frames
%  frames_per_second : animation frames per second on playback
%                      [default = 5]
%  movie_file        : GIF animation file name
%                      [default = HOME/MATLAB.gif]
%  frame_directory   : temporary directory for storing frame files
%                      [default = tempdir (Matlab function)]
%  strict_colormap   : use strict composite colormap?
%
%                       0 = use colormap from first frame for all
%                           frames
%
%                      ~0 = use composite of all individual frame 
%                           colormaps [default]
%                        
%********************************************************************
%  This is the only function needed to both build frame files and 
%  create the final animation.  Two special values of 'frame' control 
%  the process:
%
%    frame = 1            : Delete any existing files in the 
%                             frame directory
%
%    frame = total_frames : Make animated GIF from the sequence
%                             of frame GIF images and delete the 
%                             entire directory of frame image files
%********************************************************************

global HOME im_convert dirE

default('frame_directory',tempdir)
default('movie_file',[HOME 'MATLAB.gif'])
default('frames_per_second',5)
default('strict_colormap',1)

raw_format = 'png' ;

ppi = default_ppi(1) ;

flags = sprintf('-delay %d -loop 10000 ',100/frames_per_second) ;

if strict_colormap ; flags = ['+map ' flags] ; end

%--------------------------------------------------------------------
%  Remove any existing frame files before writing the first frame
%--------------------------------------------------------------------

if frame == 1
    dirE = exist(frame_directory,'dir');

    if ~dirE
        [~,~] = unix(['/bin/mkdir ' frame_directory]) ;
    else
        [~,~] = unix(['/bin/rm -f ' frame_directory 'frame*']) ;
    end
end

%--------------------------------------------------------------------
%  Save current figure window as image file in a raw format
%--------------------------------------------------------------------

raw_file = [frame_directory sprintf('frame.%4.4i.%s',frame,raw_format)] ;

fsave(raw_format,raw_file,ppi,0)

%--------------------------------------------------------------------
%  Convert raw format figure image file to GIF
%--------------------------------------------------------------------

gif_file = [frame_directory sprintf('frame.%4.4i.gif',frame)] ;

unix([im_convert ' ' raw_file ' ' gif_file ' ; /bin/rm -f ', ...
      raw_file ' &']) ;

%--------------------------------------------------------------------
%  Create animated GIF file after final frame is written
%--------------------------------------------------------------------

if frame == total_frames 
    frames  = [frame_directory 'frame*.gif '] ;

    tic  

    fprintf(1,'\n Writing animated GIF to %s\n',movie_file) ;

    pause(2)

    unix([im_convert ' '  flags  frames  movie_file]) ;

    fprintf(' Time to write GIF = %.1f seconds\n\n',toc) ;
    
    if ~dirE
        [~,~] = unix(['/bin/rm -f -r ' frame_directory]) ;
    else
        [~,~] = unix(['/bin/rm -f ' frame_directory 'frame*']) ;
    end

    clear dirE
end
