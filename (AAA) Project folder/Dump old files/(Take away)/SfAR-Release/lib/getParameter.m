function [ value ] = getParameter( strInput )
    file = fopen('config');
    fileData = textscan(file, '%s %f');
    fclose(file);
    name = fileData{1};
    number = fileData{2};
    size1 = size(fileData{2});
    sizeRow = size1(1);
    for i=1:1:sizeRow
        if strcmp(name{i},strInput)==1
            newValue = number(i);
            break;
        end
    end
    if strcmp(name{i}, strInput)==0
        error('Config Data Not Found.');
    end
    value = newValue;
%     disp (value);
end

