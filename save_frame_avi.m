function save_frame_avi(frame,nframes,frames_per_second,movie_file)

%*************************************************************************
%  SAVE_FRAME_AVI(frame,nframes,frames_per_second,movie_file)
%*************************************************************************
%  Function to save a sequence of Matlab figures to individual frames and
%  create an animated AVI movie from them.
%  See also SAVE_FRAME_FAST.m, SAVE_FRAME_STRICT.m (for GIF movies) and
%  SAVE_FRAME_MP4.m (for MP4 movies).
%*************************************************************************
%  frame             : current frame number
%  nframes           : total number of frames
%  frames_per_second : animation frames per second on playback
%                      [default = 5]
%  movie_file        : animation file name
%                      [default is HOME/MATLAB.avi]
%*************************************************************************
%  Written by Helga Huntley, December 2017
%*************************************************************************

global HOME

default('movie_file',[HOME 'MATLAB.avi'])
default('frames_per_second',5)

drawnow ; pause(0.001)

%-------------------------------------------------------------------------
% Set up movie file, if needed
%-------------------------------------------------------------------------

if frame == 1
    vid = VideoWriter(movie_file);
    vid.FrameRate = frames_per_second;
    open(vid)
end

%-------------------------------------------------------------------------
% Save frame
%-------------------------------------------------------------------------

frame = getframe(gcf);
writeVideo(vid,frame);

%-------------------------------------------------------------------------
% Close file, if needed
%-------------------------------------------------------------------------

if frame == nframes
    close(vid);
    
    fprintf(1,'\n Wrote animation to %s\n\n',movie_file) ;
end
