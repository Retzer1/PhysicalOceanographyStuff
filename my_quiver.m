function h = my_quiver(x,y,u,v,scale_factor,arrow_color,linewidth, ...
                       clipping,uniform_scale,stick)

%*************************************************************************  
%  h = MY_QUIVER(x,y,u,v,scale_factor,arrow_color,linewidth, ...
%                clipping,uniform_scale,stick)
%*************************************************************************  
%  Function for improved vector plotting that includes these 
%  additional features:
%
%  (1) a scale_factor useful for creating multiple quiver
%      plots with identical vector scaling (like for animations).
%
%  (2) automatic rescaling of (x,y) when the current axes uses an
%      m_map projection.
%
%************************************************************************* 
%  (x,y)         : Arrays of any shape that contain the (x,y)
%                  positions for the vector tail points
%  (u,v)         : Arrays of any shape that contain (u,v)
%                  velocities for the vectors 
%  scale_factor  : vector scale factor. Choosing this value depends
%                  on the spacing of (x,y) values.  Values like
%                  0.001 are typically useful.
%  arrow_color   : vector color
%  linewidth     : vector line width
%  clipping      : {'on' 'off'} clipping = 'on': no vectors are
%                  plotted outside the axes box. [default = 'on']
%  uniform_scale : if non-zero, the length of the vectors depends 
%                  on the speed irrespective of the aspect ratio
%                  of the figure; axes must be 'equal' for this
%                  option to work properly [default = 0]
%  stick         : non-zero to produce sticks centered at the points
%                  instead of arrows with tail ends at specified points
%  h             : [out] graphics handle for the vector plot
%*************************************************************************
%  See also QUIVER_LEGEND, ISMAP
%*************************************************************************

default('scale_factor',1)
default('arrow_color',[0 0 0])
default('linewidth',1)
default('clipping','on')
default('uniform_scale',0)
default('stick',0)

%-------------------------------------------------------------------------
%  Set constants for arrow head shape
%-------------------------------------------------------------------------

beta = 0.2;         % percentage of arrow length used for arrow head
tana = 0.3;         % tan(alpha), where alpha = 1/2 angle of arrow head

%-------------------------------------------------------------------------
%  Find the appropriate scaling constants
%-------------------------------------------------------------------------

ah = get(gcf,'CurrentAxes');

if isempty(ah)
    xscale = span(x); if xscale == 0; xscale = 2; end
    yscale = span(y); if yscale == 0; yscale = 2; end
else
    xscale = span(get(ah,'XLim'));
    yscale = span(get(ah,'YLim'));
end

if ~uniform_scale
    u = u(:)/xscale;
    v = v(:)/yscale;
else
    u = u(:);
    v = v(:);
end

if ismap ; [x,y] = m_ll2xy(x,y,'clip',clipping) ; end

if numel(x) ~= numel(u)
    [x,y] = ndgrid(x,y);
else
    x = x(:);
    y = y(:);
end

valid = find(isfinite(u));
Npts  = length(valid);

%-------------------------------------------------------------------------
%  Color handling
%-------------------------------------------------------------------------

if ischar(arrow_color); arrow_color = string_to_rgb(arrow_color); end

if numel(arrow_color) == 3*numel(u)
    arrow_color = reshape(arrow_color,[numel(u),3]);
    arrow_color = arrow_color(valid,:);
% else
%     arrow_color = repmat(arrow_color,[Npts,1]);
end

%-------------------------------------------------------------------------
%  Find coordinates of arrow line segments
%-------------------------------------------------------------------------

coords = complex(x(valid),y(valid)).';

z = scale_factor * complex(u(valid),v(valid)).';

if stick
    x_arrow = [0;  .5; -.5];
    y_arrow = [0;   0;   0];
else
    x_arrow = [0 1 0 1 0 1].';
    y_arrow = [0 0 0 0 0 0].';
end

Narr = length(x_arrow);

arrow = complex(x_arrow,y_arrow);       % unit arrow
a     = arrow*z;                        % rotation & velocity scaling

if ~stick                               % add vector heads
    apos = get(gca,'Position');
    fpos = get(gcf,'Position');
    ar   = apos(4)*fpos(4)/(apos(3)*fpos(3));
    
    q = complex(real(z),imag(z)*ar);
    bL    = beta*abs(q);
    theta = angle(q);
    h     = bL*tana;
    
    a(3,:) = (-bL+1i*h).*exp(1i*theta) + q;
    a(5,:) = (-bL-1i*h).*exp(1i*theta) + q;
    
    a([3 5],:) = complex(real(a([3 5],:)),imag(a([3 5],:))/ar);
end

a = complex(real(a)*xscale,imag(a)*yscale);     % scaling to grid
a = a + repmat(coords,[Narr 1]);                % translation

%-------------------------------------------------------------------------
%  Plot
%-------------------------------------------------------------------------

% c = permute(repmat(arrow_color,[1 1 Narr]),[3,1,2]);
% h = patch(real(a),imag(a),c,'LineWidth',linewidth,'EdgeColor','flat', ...
%         'Clipping',clipping) ;

if length(arrow_color) == 3
    h = plot(real(a),imag(a),'-','Color',arrow_color,...
        'LineWidth',linewidth,'Clipping',clipping);
else
    for n = 1:Npts
        h(n) = plot(real(a(:,n)),imag(a(:,n)),'-','Color',arrow_color(n,:),...
            'LineWidth',linewidth,'Clipping',clipping);
    end
end

for k = 1:length(h)
    setappdata(h(k),'vector_scale_factor',scale_factor)
end

if isempty(ah)
    if span(x) == 0
        set(gca,'XLim',[x(1)-1 x(1)+1])
    else
        set(gca,'XLim',range(x))
    end
    
    if span(y) == 0
        set(gca,'YLim',[y(1)-1 y(1)+1])
    else
        set(gca,'YLim',range(y))
    end
end
