function [row_del_index] = removeSomeEntry(frm_line, refFrm)
    row_del_index = false(size(frm_line,1),1);
    for i=1:size(frm_line,1)
        if (frm_line(i,3) <= size(refFrm, 2) / 2)
            if (frm_line(i,4) <= size(refFrm, 2) / 2) 
                row_del_index(i) = true;
            end
        end
    end
end

