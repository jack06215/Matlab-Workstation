addpath(genpath('.'));
ccc;
img = imread('data/Garfield_Building_Detroit.jpg');
img_gray = rgb2gray(img);
center = [size(img,2)/2; size(img,1)/2];
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
%% Tilt Rectification
% Line segment detection and clustering based on vanishing point
[~,ls_center,ls_label,img_vp] = vp_lineCluster(img_gray,center);
showTOVP(img,img_gray,img_vp);
% Keep only vertical line segment
[ar,~] = find(ls_label ~= 1);
ls_vertical = ls_center;
ls_vertical(:,ar) = [];

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

% % Testing code (line segment filtering)
% color = hsv(3);
% figure, imshow(img);
% hold on;
% for i=1:size(ls_filtered,2)
%    plot(ls_filtered([1,3],i), ls_filtered([2,4],i), 'Color', color(ls_label(i),:), 'LineWidth', 2);
% end

% Build image wall equally vertical strips
num_of_div = 5;
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
img_lsMidPts = zeros(size(ls_filtered,2),2);
for i=1:size(img_lsMidPts,1)
    img_lsMidPts(i,1) = (ls_filtered(1,i)+ls_filtered(3,i)) / 2;
    img_lsMidPts(i,2) = (ls_filtered(2,i)+ls_filtered(4,i)) / 2;
end
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
figure;
imshow(img), hold on;
for i=1:size(imgStripWall,2)
    plot(imgStripWall([1,3],i), imgStripWall([2,4],i), 'Color', 'red', 'LineWidth', 1);
end
color = hsv(num_of_strips);
for j=1:size(ls_categorised,2)
    ls_tmp = ls_categorised{j};
    for i=1:size(ls_tmp,2)
       plot(ls_tmp([1,3],i), ls_tmp([2,4],i), 'Color', color(j,:), 'LineWidth', 2);
    end
end
%% Experiment code
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
    imgWall = imgPlane_candidate{i};
    figure;
    imshow(img), hold on;
    for j=1:size(imgWall,2)
        plot(imgWall([1,3],j), imgWall([2,4],j), 'Color', 'red', 'LineWidth', 1);
    end
end





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

% figure;
% imshow(imgp), hold on;
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
