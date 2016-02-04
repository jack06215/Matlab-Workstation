%% 0. Setup stage
clear,close all;
minLen = 40;
img = imread('fj1.jpg');
img_bw = rgb2gray(img);

%% 1. Compute the direction and magnitude of the image intensity grdient at each pixel
[dX, dY] = gradient(conv2(double(img_bw), fspecial('gaussian', 7, 1.5), 'same'));
im_canny = edge(img_bw, 'canny');

%% 2. Quantise the gradient direction of the pixel into one set of ranges("buckets") which will serve as labels
% remove border edges
im_canny([1 2 end-1 end], :) = 0;
im_canny(:, [1 2 end-1 end]) = 0;

% Define image stride
% Used later when converting pixel index to pixel location
height = size(im_canny, 1); 

% Find all edge pixel index (from top-left down to buttom-right)
ind = find(im_canny > 0);

% Number of gradient direcion
num_dir = 8;

% Ontain dX and dY for all detected edge pixel
dX_ind = dX(ind);
dY_ind = dY(ind);

% Compute angle of orientation for all detected edge pixel
a_ind = atan(dY_ind ./ (dX_ind + 1E-10));

% Quantised gradient of ditection into num_dir = 8 labels
% a_ind ranges from 1 to num_dir with bin centered around pi/2
a_ind = ceil(mod(a_ind / pi * num_dir - 0.5, num_dir));

% Get the indices of edges in each direction, store as a list of index from
% left-top down to bottom-right.
for i = 1:num_dir
    direction(i).ind = ind(find(a_ind==i));
end

%% 3. Select a range of edge elements within a bucket range
% Declare a 9 cells array for storing "line" information
lines = zeros(2000, 9);

% Mask to compute the sum...will see later
used = zeros(size(im_canny));

line_count = 0;
for k = 1:num_dir  
    num_ind = 0; % number of edge elements for a given bucket
    
    % for each select buckets, in this case for num_dir = 8 it will be in
    % following sequence:
    % [8 1 2][1 2 3][2 3 4][3 4 5][4 5 6][5 6 7][6 7 8][7 8 1].
    % Then it will calculate the sum of elements within the buckets
    % Here ~used() is use as a mask to determine the number of element
    % inside for a given struct data type, as any non-zero integer will result
    % in 1
    for m = (k-1):k+1
        num_ind = num_ind + sum( ~used( direction( mod( m-1, num_dir ) + 1 ).ind) );
    end
%% 4. Construct a binary image and perform connect-component labeling
    ind = zeros(num_ind, 1);
    dir_im = zeros(size(im_canny)); % Line support region, binary image
    
    count = 0;  % index offset
    
    % for each bucket range, fill all of the index information from
    % direction(bucket ID).ind
    for m = (k-1):k+1
        m2 = mod(m-1, num_dir)+1;
        tind = direction(m2).ind(~used(direction(m2).ind));
        tmpcount = length(tind); % Current offset
        % Here ind will contain a list of edge index been selected within a
        % bucket range
        ind(count+1:count+tmpcount) = tind;
        count = count + tmpcount; % Total offset counter
    end
    
    % Set the bucket of edge index to 1 for being a edge pixel
    dir_im(ind) = 1;
       
    % Perform Connected-component algorithm
    [tmpL, num_edges] = bwlabel(dir_im, 8); 

%% 5. Get the number of pixels and its index in connected-component
    edge_size = zeros(num_edges, 1); % number of pixel for each connected component ID
    
    % List of index for each connected component
    edges = repmat(struct('ind', zeros(200, 1)), num_edges, 1);
    
    % for each index of edge pixel
    for i = 1:length(ind)
        % Obtain the component sequence ID
        id = tmpL(ind(i));
        
        % Increment the size of the corresponding component ID  by 1
        % In the next statement this is also use to push the data.
        edge_size(id) = edge_size(id) + 1; 
        
        % Push the pixel index..(ind(i)) to its 
        % Corresponding edge ID..(edges(id))
        edges(id).ind(edge_size(id)) = ind(i);
    end  

    % Here each edge.ind contains the list of connected component in
    % terms of index (left-top down to right-bottom)
    for i = 1:num_edges
        edges(i).ind = edges(i).ind(1:edge_size(i));
    end 
%% 6. Extract a representative line for each line support region  
    for id = 1:num_edges
         % Get the endpoints of the long edges
        if edge_size(id) > minLen         
               
            % Convert index to pixel coordinate. That is, similar to cv::Point(x,y)
            x = mod(edges(id).ind-1, height)+1;
            y = floor((edges(id).ind-1) / height)+1;                        
            
            % This is the approach by Jana Kosecka and Wei Zhang in "Video
            % Compass" , 2002, pp.3-4
            mean_x = mean(x);
            mean_y = mean(y);
            zmx = (x-mean_x);
            zmy = (y-mean_y);
            D = [sum(zmx.^2) sum(zmx.*zmy); 
                sum(zmx.*zmy) sum(zmy.^2)];
            [v, lambda] = eig(D);
            theta = atan2(v(2, 2) , v(1, 2));                       
            
            % Examine the quality of the line fit in this particular line
            % supported region
            % ...but I am not sure why such a conditional statement is made
            if lambda(1,1)>0
                conf = lambda(2,2)/lambda(1,1);
            else
                conf = 100000;
            end
            
            % Extract if the quailty indicator is above this threshold
            % value
            if conf >= 400
                
                % Line segment counter is increment by 1
                line_count = line_count+1; 
                
                % These pixels are been used, so update the mask for next
                % iteration
                used(edges(id).ind) = 1;
                %% Line segment information
                l = sqrt((max(x)-min(x))^2 + (max(y)-min(y))^2);    % l = Length              
                x1 = mean_x - cos(theta)*l/2;                       % x1 = X1-coordinates                   
                x2 = mean_x + cos(theta)*l/2;                       % x2 = X2-coordinates
                y1 = mean_y - sin(theta)*l/2;                       % y1 = Y1-coordinates
                y2 = mean_y + sin(theta)*l/2;                       % y2 = Y2-coordinates  
                theta = theta - pi / 2;                             % theta = Angle of the line
                r = mean_x * cos(theta) + mean_y * sin(theta);      % rho = Distance from the origin
                
                % Store these information into the data field respectively
                lines(line_count, 1:9) = [x1 x2 y1 y2 theta r l mean_x mean_y];
            end
        end
    end
end
% Retrun the final result
lines = lines(1:line_count, :);