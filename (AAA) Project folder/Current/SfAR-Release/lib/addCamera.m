function [ value] = addCamera(model)
 choiceInput  = input(['Do you want to add Camera Sensor Width for' model '[Y/N]:'], 's');
 if ((strcmp(lower(choiceInput), 'y')==1))
     cameraName = model;
     value = input('Please enter camera sensor width: ', 's');
     value = str2num(value);
     appendFile(value, cameraName);
     
 else
     error(['camera sensor width not provided']);
 end
end

