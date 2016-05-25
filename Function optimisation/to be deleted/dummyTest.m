addpath(genpath('.'));
A = [1;1;2;1;1;1;1;1;1;1;2;2;1];
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
