function lines = getLines(grayIm, minLen)

[dX, dY] = gradient(conv2(double(grayIm), fspecial('gaussian', 7, 1.5), 'same'));

im_canny = edge(grayIm, 'canny');

im_canny([1 2 end-1 end], :) = 0;
im_canny(:, [1 2 end-1 end]) = 0;
height = size(im_canny, 1);

ind = find(im_canny > 0);

num_dir = 8;

dX_ind = dX(ind);
dY_ind = dY(ind);
a_ind = atan(dY_ind ./ (dX_ind+1E-10));
a_ind = ceil(mod(a_ind/pi*num_dir-0.5, num_dir));

for i = 1:num_dir
    direction(i).ind = ind(find(a_ind==i));
end

lines = zeros(2000, 9);

used = zeros(size(im_canny));

line_count = 0;
for k = 1:num_dir
    
    num_ind = 0;
    for m = (k-1):k+1
        num_ind = num_ind + sum(~used(direction(mod(m-1, num_dir)+1).ind));
    end
    
    ind = zeros(num_ind, 1);
    dir_im = zeros(size(im_canny));
  
    count = 0;
    for m = (k-1):k+1
        m2 = mod(m-1, num_dir)+1;
        tind = direction(m2).ind(~used(direction(m2).ind));
        tmpcount = length(tind);
        ind(count+1:count+tmpcount) = tind;
        count = count + tmpcount;
    end
    dir_im(ind) = 1;
        
    [tmpL, num_edges] = bwlabel(dir_im, 8); 

    
    edge_size = zeros(num_edges, 1);
    edges = repmat(struct('ind', zeros(200, 1)), num_edges, 1);
    for i = 1:length(ind)
        id = tmpL(ind(i));
        edge_size(id) = edge_size(id) + 1;
        edges(id).ind(edge_size(id)) = ind(i);
    end          
    for i = 1:num_edges
        edges(i).ind = edges(i).ind(1:edge_size(i));
    end              

    for id = 1:num_edges
        if edge_size(id) > minLen         
                                    
            x = mod(edges(id).ind-1, height)+1;
            y = floor((edges(id).ind-1) / height)+1;                        
            
            mean_x = mean(x);
            mean_y = mean(y);
            zmx = (x-mean_x);
            zmy = (y-mean_y);
            D = [sum(zmx.^2) sum(zmx.*zmy); sum(zmx.*zmy) sum(zmy.^2)];
            [v, lambda] = eig(D);
            theta = atan2(v(2, 2) , v(1, 2));                       
            if lambda(1,1)>0
                conf = lambda(2,2)/lambda(1,1);
            else
                conf = 100000;
            end                
            
            if conf >= 400 
                line_count = line_count+1;           
                used(edges(id).ind) = 1;              
                l = sqrt((max(x)-min(x))^2 + (max(y)-min(y))^2);
                x1 = mean_x - cos(theta)*l/2;
                x2 = mean_x + cos(theta)*l/2;
                y1 = mean_y - sin(theta)*l/2;
                y2 = mean_y + sin(theta)*l/2;            
                
                theta = theta - pi / 2;

                r = mean_x*cos(theta)+mean_y*sin(theta);
                
                lines(line_count, 1:9) = [x1 x2 y1 y2 theta r l mean_x mean_y];
                

	
            end
        end
    end

end


lines = lines(1:line_count, :);
