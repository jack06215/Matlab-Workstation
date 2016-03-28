function [frm_line, frm_vp] = IER_VPDetection(frm)
    %% Line segment + VP detection
    frm_line = getLines(rgb2gray(frm), 40);
    frm_vp = getVP3(frm_line, size(frm, 1), size(frm, 2));

    %% Sort out VP order that vertex has the same order
    % Top -> RHS -> LHS
    % real VP location = [v1x, v2x, v3x] + width / 2 && 
    %                    [v1y, v2y, v3y] + height / 2
    % When v[i]z = 0, that means it has its VP is at inf.
    % Swap row i and j ==> matA([i,j],:) = matA([j,i],:)
    % Swap col i and j ==> matA(:,[i,j]) = matA(:,[j,i])
    % Find index..(j) and value..(i) of max value from 2 col ==> [i, j] = max(matA(:,2))
    [~, swapIdx] = min(frm_vp(:,2));
    frm_vp([1, swapIdx],:) = frm_vp([swapIdx, 1],:);

    % 2nd element for RHS AND % 3rd element for LHS
    if (frm_vp(2,1) > frm_vp(3,1))
        frm_vp([2, 3],:) = frm_vp([3, 2],:);
    end
end

