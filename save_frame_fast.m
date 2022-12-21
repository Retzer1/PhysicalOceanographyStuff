function save_frame_fast(frame,nframes,frames_per_second,movie_file, ...
                         varargin)

%********************************************************************
%  SAVE_FRAME_FAST(frame,nframes,frames_per_second,movie_file)
%********************************************************************
%  Function to save a sequence of Matlab figures to individual
%  GIF frame files and create one animated GIF movie from them.
%********************************************************************
%  This version uses a modified version of Matlab's getframe function 
%  instead of the ImageMagick routines.
%
%  PROs: (1) it works, and it's fast
%        (3) no need for ImageMagick routines
%
%  CONs: (1) All frames must use the colormap for frame 1.
%********************************************************************
%  frame             : current frame number
%  nframes           : total number of frames
%  frames_per_second : animation frames per second on playback
%                      [default = 5]
%  movie_file        : GIF animation file name
%                      [default is HOME/MATLAB.gif]
%********************************************************************

global HOME animation

default('movie_file',[HOME 'MATLAB.gif'])
default('frames_per_second',5)

drawnow ; pause(0.001)

f = my_getframe(gcf) ;

if frame == 1
    [im,animation.cmap] = rgb2ind(f.cdata,256,'nodither') ;
    animation.frames    = uint8(zeros([size(im) 1 nframes])) ;
end

animation.frames(:,:,1,frame) = rgb2ind(f.cdata,animation.cmap,'nodither') ;

if frame == nframes
    imwrite(animation.frames,animation.cmap,movie_file,'DelayTime', ...
            1/frames_per_second,'LoopCount',inf)
    
    fprintf(1,'\n Wrote animated GIF to %s\n\n',movie_file) ;
end
