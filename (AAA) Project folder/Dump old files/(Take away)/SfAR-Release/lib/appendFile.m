function [] = appendFile(value, name)
    file = fopen('camerasensorwidths.txt', 'a');
    format = '\n%s';
    fileData = fprintf(file, format,[num2str(value) ' ' name '\r\n']);
    fclose(file);
end

