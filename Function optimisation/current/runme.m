ccc;
addpath(genpath('.'));
img = imread('data/buildin33.jpg');
img_gray = rgb2gray(img);
center = [size(img,2)/2; size(img,1)/2];
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
%% Algorithm starts from here
% Line segment detection and clustering based on vanishing point
[ls,ls_center,ls_label] = vp_lineCluster(img_gray,center);

% Keep only vertical line segment
ar = find(ls_label==2 | ls_label==3);
ls_center_filtered = ls_center;
ls_center_filtered(:,ar) = [];

% Camera tilt rectification using Levenberg-Marquardt optimisation method
x = tiltRectification(ls_center_filtered,K);

% Obtain the result warping image
[imgp,T] = getPerspectiveImg(img,x,K);
T_H = T.T;

%% Experiment code(back-projection)
sz = size(img);
% Original pixel index lookup table
[rows,cols]= meshgrid(1:sz(1), 1:sz(2));
B = [reshape(cols,1,[]);
     reshape(rows,1,[]);
     ones(1,length(rows(:)))]; 
BB = T_H' * B;
BB = BB ./ [BB(3,:); BB(3,:); BB(3,:)];
BB = int32(BB); % Truncate from float to int
ptYp_1 = BB(2,:) - min(BB(2,:)) +1;
ptXp_1 = BB(1,:) - min(BB(1,:)) +1;
ptXYp = [ptXp_1;ptYp_1];


num_of_strips = 13;
imgStripWall = ones(4,num_of_strips);
offset = [size(img,2)/num_of_strips;0;size(img,2)/num_of_strips;0];
for i=1:size(imgStripWall,2)
    imgStripWall(:,i) = imgStripWall(:,i) + (i-1)*offset;
end
imgStripWall(4,:) = size(img,1);


% Keep only horizontal line segment
ar = find(ls_label==1);
ls_center_filtered = ls_center;
ls_filtered = ls;

ls_filtered(:,ar) = [];
ls_center_filtered(:,ar) = [];
img_lsMidPts = zeros(2,size(ls_filtered,2));
for i=1:size(img_lsMidPts,2)
    img_lsMidPts(1,i) = (ls_filtered(1,i)+ls_filtered(3,i)) / 2;
    img_lsMidPts(2,i) = (ls_filtered(2,i)+ls_filtered(4,i)) / 2;
end
% %% Obtain image strip
% imgCells = getImgStrips(imgp,13);
% imgStrips_ls = cell(size(imgCells));
% imgStrips_ls_offset = cell(size(imgCells));
% imgStrips_ls_offset_filtered = cell(size(imgCells));
% imgStrips_ls_offset_filtered_A = cell(size(imgCells));
% offset = [size(imgCells{1,1},2);0;size(imgCells{1,1},2);0];
% for i=1:size(imgStrips_ls,2)
%     imgStrip_i = imgCells{1,i};
%     imgStrip_i_ls = getLines(rgb2gray(imgStrip_i),20);
%     imgStrip_i_ls = imgStrip_i_ls(:,1:4)';
%     imgStrip_i_ls = [imgStrip_i_ls(1,:); imgStrip_i_ls(3,:); imgStrip_i_ls(2,:); imgStrip_i_ls(4,:)];
%     imgStrips_ls{1,i} = imgStrip_i_ls;
%     imgStrips_ls_offset{1,i} = imgStrip_i_ls + ((i - 1).*repmat(offset,1,size(imgStrip_i_ls,2))); 
% end
% for i=1:size(imgStrips_ls_offset,2)
%     imgStrips_L_offset = twopts2L(imgStrips_ls_offset{1,i});
%     lineSeg = imgStrips_ls_offset{1,i};
%     Vp = imgStrips_L_offset(1:2,:);
%     Vp = Vp./repmat(sqrt(sum(Vp.^2)),2,1);
%     
%     for j=1:size(Vp,2)
%         if acosd(abs(Vp(:,j))'*[1;0]) <= 30
%             lineSeg(:,j)=0;
%         end
%     end
%     checking = sum(lineSeg);
%     for k=size(checking,2):-1:1
%         if checking(k) == 0
%             lineSeg(:,k)=[];
%         end
%     end
%     imgStrips_ls_offset_filtered{1,i}=lineSeg;
%     A = ones(size(imgStrips_ls_offset_filtered{1,i},2));
%     A(logical(eye(size(A)))) = 0;
%     A = triu(A);
%     imgStrips_ls_offset_filtered_A{1,i} = A;
% end

% Show result
figure;
imshow(img), hold on;
for i=1:size(imgStripWall,2)
    plot(imgStripWall([1,3],i), imgStripWall([2,4],i), 'Color', 'red', 'LineWidth', 2);

end

for i=1:size(ls_filtered,2)
   plot(ls_filtered([1,3],i), ls_filtered([2,4],i), 'Color', 'cyan', 'LineWidth', 2);
   
end
   plot(img_lsMidPts(1,:), img_lsMidPts(2,:),'x', 'Color', 'black', 'LineWidth', 2);

% ind = 4;
% for index=1:size(imgStrips_ls_offset_filtered,2)
%     imgStrip_1_ls = imgStrips_ls_offset_filtered{1,index};
%     for i=1:size(imgStrip_1_ls,2)
%         plot(imgStrip_1_ls([1,3],i), imgStrip_1_ls([2,4],i), 'Color', 'red', 'LineWidth', 1);
%     end
%     pause(0.1);
% end
