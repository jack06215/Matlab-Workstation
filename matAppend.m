%% Adding dynamic memory block (not so good version)
clc;
% block_size = 10000;
% list_size = block_size;
% myList = zeros(block_size, 1);
% myList_ptr = 1;
% 
% max = floor( rand * 1e4 );  % Who knows how many elements will be added?
% for i=1:max
%     myList(i) = rand * 1e2;
%     myList_ptr = myList_ptr + 1;
%     
%     % Add new block of memory if needed
%     if( myList_ptr + (block_size/10) > myList_ptr )  % less than 10%*BLOCK_SIZE free slots
%         list_size = list_size + block_size;       % add new BLOCK_SIZE slots
%         myList(myList_ptr+1:list_size,:) = 0;
%     end
% end
% myList(myList_ptr:end) = [];

%% Adding memory block (better version)
max = floor( rand * 1e5 );  % Who knows how many elements will be added?
t = tic;
vector = 0;
counter = 0;
while( counter < max )
    counter = counter + 1;    
    if (counter > length(vector))
        vector(end+1, end+length(vector)) = 0;
%         fprintf(1, 'Vector now has length %d\n', length(vector));
    end
    vector(counter) = counter;
end
vector = vector(1:counter); % Trim excess capacity
fprintf(1, 'Vector has the final length %d\n', length(vector));
disp(['Total elapsed time = ',num2str(toc(t)),' sec.'])