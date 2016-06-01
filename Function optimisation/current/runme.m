addpath(genpath('.'));
ccc;
img = imread('data/018.jpg');
img_gray = rgb2gray(img);
% figure,hold on
% imshow(img);
% hold off;
center = [size(img,2)/2; size(img,1)/2];
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
%% Tilt Rectification
% Line segment detection and clustering based on vanishing point
[ls,ls_center,ls_label,img_vp] = vp_lineCluster(img_gray,center);
% showTOVP(img,img_gray,img_vp);
% Keep only vertical line segment
[ar,~] = find(ls_label ~= 1);
ls_vertical = ls_center;
ls_vertical(:,ar) = [];
% ls_vertical(:,3) = [];
ls(:,ar) = [];
% ls(:,3) = [];
% figure;
% imshow(img), hold on;
% for i=1:size(ls,2)
%     plot(ls([1,3],i), ls([2,4],i), 'Color', [0,0,1], 'LineWidth', 3);
% %     pause(1);
% end

% Camera tilt rectification using Levenberg-Marquardt optimisation method
x = tiltRectification(ls_vertical,K);

% Obtain the result warping image
[imgp,T] = getPerspectiveImg(img,x,K);
H = T.T;
% figure,imshow(imgp);
[ls,ls_center,ls_label,~] = vp_lineCluster(img_gray,center,15);
%% Build image strips wall (equally divided)
% Remove all vertical line segments
[ar,~] = find(ls_label == 1);
ls_filtered = ls;
ls_filtered(:,ar) = [];
ls_label(ar)=[];
ls_filtered = [ls_filtered; ls_label'];

%---------------------------------------- Testing code (line segment filtering)
color = hsv(size(ls,2));
color_hex = rgb2hex(color);
% figure, imshow(img);
% hold on;
% list_A = [174,54,167,84];
% quad_a = ls(:,list_A(:));
% 
% % Sort out line segments
% L = twopts2L(quad_a);
% ref = repmat(-eps,(size(L(1:2,:))));
% diff = abs(L(1:2,:)) - ref;
% [~,ind_a] = min(diff,[],1);
% [~,ind_a] = sort(ind_a);
% L_sort = L(:,ind_a);
% 
% combinations = [1,3;...
%                 1,4;...
%                 2,3;...
%                 2,4;];
% 
% quad = zeros(2,4);            
% for i=1:size(combinations,1)
%     lv1 = L_sort(:,combinations(i,1));
%     lv2 = L_sort(:,combinations(i,2));
%     tmp = az_hcross(lv1,lv2);
%     quad(:,i) = tmp(1:2);
% end
% 
% 
% for i=1:size(list_A,2)
%    plot(ls([1,3],list_A(i)), ls([2,4],list_A(i)), 'Color', 'red', 'LineWidth', 2);
%    plot(quad(1,i),quad(2,i),'x','Color','black','LineWidth',2);
% end

% Build image wall equally vertical strips
num_of_div = 6;
num_of_strips = 1 + num_of_div*2;
imgStripWall = ones(4,num_of_strips+1);
offset = [size(img,2)/num_of_strips;0;size(img,2)/num_of_strips;0];
for i=1:size(imgStripWall,2)
    imgStripWall(:,i) = imgStripWall(:,i) + (i-1)*offset;
end
imgStripWall(4,:) = size(img,1);
imgStripWall(:,end) = [size(img,2);1;size(img,2);size(img,1)];

% Build image will w.r.t. H
% sz = size(img);
% [rows,cols]= meshgrid(1:sz(1), 1:sz(2));
% B = [reshape(cols,1,[]);
%      reshape(rows,1,[]);
%      ones(1,length(rows(:)))]; 
% BB = H' * B;
% BB = BB ./ [BB(3,:); BB(3,:); BB(3,:)];
% BB = int32(BB); % Truncate from float to int
% ptYp_1 = BB(2,:) - min(BB(2,:)) +1;
% ptXp_1 = BB(1,:) - min(BB(1,:)) +1;
% ptXYp = [ptXp_1;ptYp_1];
% B = B(1:2,:);
% strips_proj = zeros(size(imgStripWall));
% for i=1:size(imgStripWall,2)
%     ls1a_ind = floor(imgStripWall(1,i)) + ((floor(imgStripWall(2,i)) - 1) * sz(2));
%     ls1b_ind = floor(imgStripWall(3,i)) + ((floor(imgStripWall(4,i)) - 1) * sz(2));
%     strips_proj(:,i) = [ptXYp(:,ls1a_ind); ptXYp(:,ls1b_ind)];
% end

% Categorise line segment w.r.t. image strip
% Length and midpoint
img_lsMidPts = zeros(size(ls_filtered,2),2);
img_lsLength = zeros(size(ls_filtered,2),1);
for i=1:size(img_lsMidPts,1)
    img_lsMidPts(i,1) = (ls_filtered(1,i)+ls_filtered(3,i)) / 2;
    img_lsMidPts(i,2) = (ls_filtered(2,i)+ls_filtered(4,i)) / 2;
    L2 = (ls_filtered(1,i)-ls_filtered(3,i))^2 + (ls_filtered(2,i)+ls_filtered(4,i))^2;
    img_lsLength(i) = sqrt(L2);
end
ls_filtered = [ls_filtered; img_lsLength'];
% ls_categorised_p = cell(1,num_of_strips);
ls_categorised = cell(1,num_of_strips);
for i=1:num_of_strips
%     x_tmp(:,i) = [imgStripWall(1,i),imgStripWall(1,i+1),imgStripWall(3,i+1),imgStripWall(3,i),imgStripWall(1,i)];
%     y_tmp(:,i) = [imgStripWall(2,i),imgStripWall(2,i+1),imgStripWall(4,i+1),imgStripWall(4,i),imgStripWall(2,i)];
    xv = [imgStripWall(1,i),imgStripWall(1,i+1),imgStripWall(3,i+1),imgStripWall(3,i),imgStripWall(1,i)];
    yv = [imgStripWall(2,i),imgStripWall(2,i+1),imgStripWall(4,i+1),imgStripWall(4,i),imgStripWall(2,i)];
    xq = img_lsMidPts(:,1);
    yq = img_lsMidPts(:,2);
    [in,~] = inpolygon(xq,yq,xv,yv);
    ind = find(in==1);
    ls_tmp = ls_filtered(:,ind);
    ls_categorised{i}=ls_tmp;
    
%     % Line segment in its perspective view
%     ls_tmp = ls_categorised{i};
%     ls1_proj = zeros(size(ls_tmp));
%     for j=1:size(ls_tmp,2)
%         ls1a_ind = floor(ls_tmp(1,j)) + ((floor(ls_tmp(2,j)) - 1) * sz(2));
%         ls1b_ind = floor(ls_tmp(3,j)) + ((floor(ls_tmp(4,j) - 1) * sz(2)));
%         ls1_proj(:,j) = [ptXYp(:,ls1a_ind); ptXYp(:,ls1b_ind)];
%     end
%     ls_categorised_p{i} = ls1_proj;
end

% for i=1:size(imgStripWall,2)
%     figure;
%     imshow(img), hold on;
%     plot(imgStripWall([1,3],i), imgStripWall([2,4],i), 'Color', 'red', 'LineWidth', 1);
% end
% hold off
% color = hsv(num_of_strips);
% for j=1:size(ls_categorised,2)
%     ls_tmp = ls_categorised{j};
%     for i=1:size(ls_tmp,2)
%        plot(ls_tmp([1,3],i), ls_tmp([2,4],i), 'Color', color(j,:), 'LineWidth', 2);
%     end
% end
% hold off;
% % Build image strips wall (divide inwardly)
sz = size(imgStripWall,2)/2;
imgPlane_candidate = cell(1,num_of_div*2);
boo = true(1,num_of_div*2);
boo(2:2:end)=0;

head = ones(1,num_of_div);
tail = ones(1,num_of_div);
sum = num_of_strips+1;

for i=1:num_of_div
    tail(i) = size(imgStripWall,2) - i;
    head(i) = sum - tail(i);
    head(i) = head(i) + 1;
end
head = reshape(flipud(reshape(head,2,[])),size(head));
tail = reshape(flipud(reshape(tail,2,[])),size(tail));
for i=1:size(imgPlane_candidate,2)+1
    plane_wall = ones(4,2+1*(i-1));
    plane_wall(:,1) = imgStripWall(:,1);
    plane_wall(:,2) = imgStripWall(:,end);
    remainCols = size(plane_wall,2)-2;
    ind1=1;
    ind2=1;
    select=boo(1:remainCols);
    for j=1:remainCols
        if (select(j))
            plane_wall(:,2+j) = imgStripWall(:,tail(ind1)); ind1=ind1+1;
        else
            plane_wall(:,2+j) = imgStripWall(:,head(ind2)); ind2=ind2+1;
        end
    end
%     disp(num2str(remainCols));
%     select=boo(1:remainCols);
%     for j=1:remainCols
%         disp(num2str(int32(j/2)));
%         if (select(j))
% %             plane_wall(:,1+j) = imgStripWall(:,end-(1+j));
%         else
%             plane_wall(:,1+j) = imgStripWall(:,1+int32(j/2));
%         end
%     end
%     disp('==========');
    [~,ind]= sort(plane_wall(1,:));
    plane_wall(:,1:size(plane_wall,2)) = plane_wall(:,ind);
    imgPlane_candidate{i} = plane_wall;
end

for i=1:size(imgPlane_candidate,2)
    tmp2 = imgPlane_candidate{i};
    figure(2), imshow(img);
    hold on;
    for j=1:size(tmp2,2)
        plot(tmp2([1,3],j), tmp2([2,4],j), 'Color', 'red', 'LineWidth', 1);
    end
    hold off;
end


imgPlane_ls_candidate = cell(size(imgPlane_candidate));
for i=1:size(imgPlane_ls_candidate,2)
%     imgPlane_ls_candidate{i} = [];
    boundingBox = imgPlane_candidate{i};
    ls_candidate_tmp = cell(1,i);
    for j=1:size(boundingBox,2)-1
%         disp(num2str(j));
        xv = [boundingBox(1,j),boundingBox(1,j+1),boundingBox(3,j+1),boundingBox(3,j),boundingBox(1,j)];
        yv = [boundingBox(2,j),boundingBox(2,j+1),boundingBox(4,j+1),boundingBox(4,j),boundingBox(2,j)];
        xq = img_lsMidPts(:,1);
        yq = img_lsMidPts(:,2);
        [in,~] = inpolygon(xq,yq,xv,yv);
        ind = find(in==1);
        ls_tmp = ls_filtered(:,ind);
%         disp(num2str(size(ls_tmp)));
        ls_candidate_tmp{j}=ls_tmp;
    end
    imgPlane_ls_candidate{i} = ls_candidate_tmp;
%     disp('---------------');
end

%% Experiment code
% Plane candidate evaluation
imgPlane_extracted_candidate = cell(size(imgPlane_ls_candidate));
for i=1:size(imgPlane_extracted_candidate,2) 
    extracted_candidate = imgPlane_ls_candidate{i};
    candidate_evaluation = zeros(size(extracted_candidate,2),2);
    for j=1:size(candidate_evaluation,1)
        clear sum;
        candidate_score = zeros(1,2);
        current_extracted_plane = extracted_candidate{j};
        all_ls = sum(current_extracted_plane(6,:));
        ind1 = find(current_extracted_plane(5,:) == 2);
        ind2 = find(current_extracted_plane(5,:) == 3);
        candidate_score(1) = sum(current_extracted_plane(6,ind1));
        candidate_score(1) = candidate_score(1)/all_ls;
        candidate_score(2) = sum(current_extracted_plane(6,ind2));
        candidate_score(2) = candidate_score(2)/all_ls;
        candidate_evaluation(j,:) = candidate_score;
    end
    imgPlane_extracted_candidate{i} = candidate_evaluation;
end


% Show result
% color = hsv(size(imgPlane_candidate,2));
% for i=1:size(imgPlane_candidate,2)
%     imgWall = imgPlane_candidate{i};
%     hfig = figure(3);
%     imshow(img), hold on;
%     for j=1:size(imgWall,2)
%         plot(imgWall([1,3],j), imgWall([2,4],j), 'Color', color(i,:), 'LineWidth', 3);
% %         pause(0.5);
%     end
% %     pause(1);
%     hold off;
% end
% Image strip area percentage w.r.t. entire image area
imgStrip_area_pa = cell(size(imgPlane_candidate));
for i=1:size(imgStrip_area_pa,2)
    tmp1 = imgPlane_candidate{i};
    area_pa = zeros(1,size(tmp1,2)-1);
    img_area = size(img,2) * size(img,1);
    for j=1:size(tmp1,2)-1
        img_wall_1 = tmp1(1,j);
        img_wall_2 = tmp1(1,j+1);
        area_pa(j) = (img_wall_2 - img_wall_1+1)*size(img,1) / img_area;
    end
    imgStrip_area_pa{i} = area_pa;
end

imgPlane_label = cell(size(imgPlane_candidate));
imgPlane_candidate_max = cell(size(imgPlane_candidate));
for i=1:size(imgPlane_label,2)
    tmp = imgPlane_extracted_candidate{i};
    [a,b]=max(tmp, [], 2);
    imgPlane_label{i} = b;
    imgPlane_candidate_max{i} = a;
end

imgPlane_candidate_score = zeros(num_of_strips,1);
for i=1:size(imgPlane_candidate_score,1)
    plane_score = imgPlane_candidate_max{i};
    area_pa = imgStrip_area_pa{i};
    imgPlane_candidate_score(i) = dot(plane_score,area_pa);
end


% Find boundary
addpath(genpath('.'));
A = imgPlane_label{end};
counter = 0;
list = 0;
for i=1:size(A,1) - 1
    if A(i) ~= A(i+1)
        counter = counter + 1;
        if (counter > length(list))
            list(end+1, end+length(list)) = 0;
        end
        list(counter) = i+1;
    end
end
list = list(1:counter); % Trim excess capacity
list = [1,list];
delta = diff(list);
[~,delta_ind] = sort(delta,'descend');
ind = list(delta_ind(1)+1);

imgPlane_boundary = imgStripWall(:,ind);
figure, imshow(img);
hold on;
plot(imgPlane_boundary([1,3]), imgPlane_boundary([2,4]), 'Color', 'red', 'LineWidth', 3);
hold off;



% for i=1:num_of_strips
%     xv = x_tmp(:,i);
%     yv = y_tmp(:,i);
%     xq = img_lsMidPts(:,1);
%     yq = img_lsMidPts(:,2);
%     [in,on] = inpolygon(xq,yq,xv,yv);
%     ind = find(in==1);
%     ls_tmp = ls_filtered(:,ind);
%     ls_categorised{i}=ls_tmp;
% end
% [in,on] = inpolygon(img_lsMidPts(:,1), img_lsMidPts(:,2),x_tmp(:,5),y_tmp(:,5));

% 
% 
% % Keep only horizontal line segment
% ar = find(ls_label==1);
% ls_center_filtered = ls_center;
% ls_filtered = ls;
% 
% ls_filtered(:,ar) = [];
% ls_center_filtered(:,ar) = [];
% img_lsMidPts = zeros(2,size(ls_filtered,2));
% for i=1:size(img_lsMidPts,2)
%     img_lsMidPts(1,i) = (ls_filtered(1,i)+ls_filtered(3,i)) / 2;
%     img_lsMidPts(2,i) = (ls_filtered(2,i)+ls_filtered(4,i)) / 2;
% end
% % %% Obtain image strip
% % imgCells = getImgStrips(imgp,13);
% % imgStrips_ls = cell(size(imgCells));
% % imgStrips_ls_offset = cell(size(imgCells));
% % imgStrips_ls_offset_filtered = cell(size(imgCells));
% % imgStrips_ls_offset_filtered_A = cell(size(imgCells));
% % offset = [size(imgCells{1,1},2);0;size(imgCells{1,1},2);0];
% % for i=1:size(imgStrips_ls,2)
% %     imgStrip_i = imgCells{1,i};
% %     imgStrip_i_ls = getLines(rgb2gray(imgStrip_i),20);
% %     imgStrip_i_ls = imgStrip_i_ls(:,1:4)';
% %     imgStrip_i_ls = [imgStrip_i_ls(1,:); imgStrip_i_ls(3,:); imgStrip_i_ls(2,:); imgStrip_i_ls(4,:)];
% %     imgStrips_ls{1,i} = imgStrip_i_ls;
% %     imgStrips_ls_offset{1,i} = imgStrip_i_ls + ((i - 1).*repmat(offset,1,size(imgStrip_i_ls,2))); 
% % end
% % for i=1:size(imgStrips_ls_offset,2)
% %     imgStrips_L_offset = twopts2L(imgStrips_ls_offset{1,i});
% %     lineSeg = imgStrips_ls_offset{1,i};
% %     Vp = imgStrips_L_offset(1:2,:);
% %     Vp = Vp./repmat(sqrt(sum(Vp.^2)),2,1);
% %     
% %     for j=1:size(Vp,2)
% %         if acosd(abs(Vp(:,j))'*[1;0]) <= 30
% %             lineSeg(:,j)=0;
% %         end
% %     end
% %     checking = sum(lineSeg);
% %     for k=size(checking,2):-1:1
% %         if checking(k) == 0
% %             lineSeg(:,k)=[];
% %         end
% %     end
% %     imgStrips_ls_offset_filtered{1,i}=lineSeg;
% %     A = ones(size(imgStrips_ls_offset_filtered{1,i},2));
% %     A(logical(eye(size(A)))) = 0;
% %     A = triu(A);
% %     imgStrips_ls_offset_filtered_A{1,i} = A;
% % end
% 


%% Show result


% plot(img_lsMidPts(:,1), img_lsMidPts(:,2),'x', 'Color', 'black', 'LineWidth', 2);
% 
% figure;
% imshow(imgp);
% for i=1:size(strips_proj,2)
%     plot(strips_proj([1,3],i), strips_proj([2,4],i), 'Color', 'red', 'LineWidth', 1);
% end
% for i=1:num_of_strips
%     ls_tmp = ls_categorised_p{i};
%     for j=1:size(ls_tmp,2)
%         plot(ls_tmp([1,3],j), ls_tmp([2,4],j), 'Color', color(i,:), 'LineWidth', 2);
%     end
% end
% hold off



% 
% % ind = 4;
% % for index=1:size(imgStrips_ls_offset_filtered,2)
% %     imgStrip_1_ls = imgStrips_ls_offset_filtered{1,index};
% %     for i=1:size(imgStrip_1_ls,2)
% %         plot(imgStrip_1_ls([1,3],i), imgStrip_1_ls([2,4],i), 'Color', 'red', 'LineWidth', 1);
% %     end
% %     pause(0.1);
% % end
