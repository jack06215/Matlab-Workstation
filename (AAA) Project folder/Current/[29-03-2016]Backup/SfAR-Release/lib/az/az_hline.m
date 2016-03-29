% AZ_HLINE - Plot 2D lines defined in homogeneous coordinates.
% edited by az to fix:
% 1) when axes limits start from negative
% 2) also fixes functionality when an axes is not square
% 3) fixed so that it could work for lines passing through origin
% 4) uses az_hcross instead of hcross
% put in azutil on 11th March 2009
%
%
% HLINE - Plot 2D lines defined in homogeneous coordinates.
%
% Function for ploting 2D homogeneous lines defined by 2 points
% or a line defined by a single homogeneous vector
%
% Usage:   hline(p1,p2)   where p1 and p2 are 2D homogeneous points.
%          hline(p1,p2,'colour_name')  'black' 'red' 'white' etc
%          hline(l)       where l is a line in homogeneous coordinates
%          hline(l,'colour_name')
%

%  Peter Kovesi
%  School of Computer Science & Software Engineering
%  The University of Western Australia
%  pk @ csse uwa edu au
%  http://www.csse.uwa.edu.au/~pk
%
%  April 2000

function az_hline(a,b,c)

col = 'blue';  % default colour

if nargin >= 2 & isa(a,'double')  & isa(b,'double')   % Two points specified

  p1 = a./a(3);        % make sure homogeneous points lie in z=1 plane
  p2 = b./b(3);

  if nargin == 3 & isa(c,'char')  % 2 points and a colour specified
    col = c;
  end

elseif nargin >= 1 & isa(a,'double')       % A single line specified

%%% edit by aZ
%   a = a./a(3);   % ensure line in z = 1 plane (not needed?? it's incorrect and dangerous - lines could pass from origin)
%%%

%   if abs(a(1)) > abs(a(2))   % line is more vertical
%     ylim = get(get(gcf,'CurrentAxes'),'Ylim');
%     p1 = hcross(a, [0 1 0]');
%     p2 = hcross(a, [0 -1/ylim(2) 1]');
%   else                       % line more horizontal
%     xlim = get(get(gcf,'CurrentAxes'),'Xlim');
%     p1 = hcross(a, [1 0 0]');
%     p2 = hcross(a, [-1/xlim(2) 0 1]');
%   end

%%% start edit by aZ
    % get the axes limits
    xlim = get(get(gcf,'CurrentAxes'),'Xlim');
    ylim = get(get(gcf,'CurrentAxes'),'Ylim');
    % take the four intersections
    p(1,:)=az_hcross(a, az_hcross([xlim(1);ylim(1);1],[xlim(1);ylim(2);1]));
    p(2,:)=az_hcross(a, az_hcross([xlim(1);ylim(1);1],[xlim(2);ylim(1);1]));
    p(3,:)=az_hcross(a, az_hcross([xlim(2);ylim(2);1],[xlim(1);ylim(2);1]));
    p(4,:)=az_hcross(a, az_hcross([xlim(2);ylim(2);1],[xlim(2);ylim(1);1]));
    % check whether the lines was parallel to any principle axis
    if any(p(:,3)==0)
        % then keep the two finite intersection points only
        p=p(p(:,3)>0,:);
        if size(p,1)~=2 % it is possible that h-coordinate is zero for some other reason (a=[0,0,0]?)
            warning('az_hline -> input line is invalid');
            return
        end
        p1=p(1,:);
        p2=p(2,:);
    else
        % otherwise drop the two points with maximum distance to each other
        % it is safe to compute distance in any one dimension since the
        % line is not parallel to any of the principle axes
        [dummy,porder]=sort(p(:,1));
        p1 = p(porder(2),:);
        p2 = p(porder(3),:);
    end

%%% end edit by aZ


  if nargin == 2 & isa(b,'char') % 1 line vector and a colour specified
    col = b;
  end

else
  error('Bad arguments passed to hline');
end

line([p1(1) p2(1)], [p1(2) p2(2)], 'color', col);
