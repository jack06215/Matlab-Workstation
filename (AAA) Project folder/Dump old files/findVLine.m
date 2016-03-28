function ix = findVLine(line,VPTheta,VPRadius,M,N)
if isnan(VPTheta) || isnan(VPRadius)
    ix = [];
    return;
end
if VPRadius < inf
    vp = [VPRadius.*cos(VPTheta) VPRadius.*sin(VPTheta)];
    line_mid = [(line(:,3) + line(:,4))/2 - N/2 (line(:,1) + line(:,2))/2 - M/2];
    line_vec = [(line(:,3) - line(:,4)) (line(:,1) - line(:,2))];
    lvp_vec = line_mid - repmat(vp,size(line_mid,1),1);
    line_len_sq = line_vec(:,1).*line_vec(:,1) + line_vec(:,2).*line_vec(:,2);
    lvp_len_sq = lvp_vec(:,1).*lvp_vec(:,1) + lvp_vec(:,2).*lvp_vec(:,2);
    line_proj_sq = zeros(size(line,1),1);
    for j = 1:size(line,1)
        line_proj_sq(j) = lvp_vec(j,:) * (line_vec(j,:))';
    end
    line_proj_sq = line_proj_sq.*line_proj_sq/4;
    line_proj_sq = line_proj_sq./lvp_len_sq;
    line_err = sqrt(line_len_sq/4 - line_proj_sq);
    ix = find((line_err < 5 & line_len_sq > 400 )|(line_len_sq < 400 & line_err < 1));
else
    vp = [cos(VPTheta) sin(VPTheta)];
    line_mid = [(line(:,3) + line(:,4))/2 - N/2 (line(:,1) + line(:,2))/2 - M/2];
    line_vec = [(line(:,3) - line(:,4)) (line(:,1) - line(:,2))];
    lvp_vec = repmat(vp,size(line_mid,1),1);
    line_len_sq = line_vec(:,1).*line_vec(:,1) + line_vec(:,2).*line_vec(:,2);
    lvp_len_sq = lvp_vec(:,1).*lvp_vec(:,1) + lvp_vec(:,2).*lvp_vec(:,2);
    line_proj_sq = zeros(size(line,1),1);
    for j = 1:size(line,1)
        line_proj_sq(j) = lvp_vec(j,:) * (line_vec(j,:))';
    end
    line_proj_sq = line_proj_sq.*line_proj_sq/4;
    line_proj_sq = line_proj_sq./lvp_len_sq;
    line_err = sqrt(line_len_sq/4 - line_proj_sq);
    ix = find((line_err < 5 & line_len_sq > 400 )|(line_len_sq < 400 & line_err < 1));
end