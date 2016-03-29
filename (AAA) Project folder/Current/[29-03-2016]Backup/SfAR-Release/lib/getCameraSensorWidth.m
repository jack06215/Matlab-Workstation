function w=getCameraSensorWidth(camModel)

fid=fopen('camerasensorwidths.txt','r');
w=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break;
    end
    
    if strfind(tline,camModel)
        disp(tline)
        w=str2double(strtok(tline));
        break;
    end
end
fclose(fid);
