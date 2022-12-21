function save_frame(frame,total_frames,frames_per_second, ...
                    movie_file,frame_directory,strict_colormap)

%*************************************************************************
%  SAVE_FRAME(frame,total_frames,frames_per_second,movie_file, ...
%             frame_directory,strict_colormap)
%*************************************************************************
%  Function to create an animation from a sequence of Matlab figures.
%  If the file format is a GIF, then individual frame files are saved and
%  combined into a single animated GIF.  The 'strict_colormap' option uses 
%  the ImageMagick convert command to apply a single 256 color map to 
%  all GIF frames.
%*************************************************************************
%  frame             : current frame number
%  total_frames      : total number of frames
%  frames_per_second : animation frames per second on playback
%                      [default = 5]
%  movie_file        : animation file name
%                      [default = HOME/MATLAB.gif]
%  frame_directory   : temporary directory for storing frame files
%                      when file format is GIF and strict_colormap ~= 0.
%                      [default = tempdir (Matlab function)]
%  strict_colormap   : use strict composite colormap? (for GIF only)
%
%                       0 = use colormap from first frame for all
%                           frames [default]
%
%                      ~0 = use composite of all individual frame 
%                           colormaps
%
%                       NOTE: This option uses the ImageMagick 
%                             'convert' command. The global variable 
%                             'im_convert' (normally set in startup.m) 
%                              must contain the path to this command.
%
%*************************************************************************
%  This is the only function needed to both build frame files and 
%  create the final animation.  Two special values of 'frame' control 
%  the process:
%
%  frame = 1            : Delete any existing files in the 
%                         frame directory, or create video file
%
%  frame = total_frames : Make animated GIF from the sequence
%                         of frame GIF images and delete the 
%                         entire directory of frame image files, 
%                         or close video file
%*************************************************************************
%  Edited December 2017 by Helga Huntley to include non-GIF capability
%*************************************************************************

global HOME

default('frame_directory',tempdir)
default('movie_file',[HOME 'MATLAB.gif'])
default('frames_per_second',5)
default('strict_colormap',0)

suff = suffix(movie_file);

switch suff
    case 'avi'
        save_frame_avi(frame,total_frames,frames_per_second,movie_file)
    case 'mp4'
        save_frame_mp4(frame,total_frames,frames_per_second,movie_file)
    case 'gif'
        saveframe = {@save_frame_fast @save_frame_strict} ;
        n         = logical(strict_colormap)+1 ;
        
        saveframe{n}(frame,total_frames,frames_per_second, ...
             movie_file,frame_directory,strict_colormap)
    otherwise
        error(['This movie file format is not supported.\n' ...
            'Choose from avi, mp4, or gif.'])
end
