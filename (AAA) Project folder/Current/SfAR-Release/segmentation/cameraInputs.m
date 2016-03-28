function [im, K,center] = cameraInputs(impath,scaleimageflag)

%% check if the image file exists
if ~exist(impath,'file')
    error('Please enter a valid image path');
end
%% read camera data
imexif=imfinfo(impath);
%imexif=exifread(impath);
if isempty(imexif) || ~isfield(imexif.DigitalCamera,'FocalLength') || ~isfield(imexif,'Model')
%if isempty(imexif) || ~isfield(imexif,'FocalLength') || ~isfield(imexif,'Model')
    error('EXIF read failed');
end
w=getCameraSensorWidth(strtrim(imexif.Model));
if ~w
    disp('Unable to read Camera Sensor Width.');
    [value] = addCamera(strtrim(imexif.Model));
    if ~value
        error(['unable to read camera sensor width, example line ''22.2 ',imexif.Model, '''']);
    else
        w = value;
    end;
end;

%% scale the image
im=imread(impath);
if scaleimageflag == 1 && max([size(im,1),size(im,2)])>1000
    imscale=1000/max([size(im,1),size(im,2)]);
    im=imresize(im,imscale);
end

%% define the intrinsic parameters under square pixel assumption
% f=imexif.FocalLength*max(size(im))/w;
f=imexif.DigitalCamera.FocalLength*max(size(im))/w;
u0=size(im,2)/2; v0=size(im,1)/2;
K=diag([f,f,1]);
center = [u0; v0];
%K(1:2,3) = [u0;v0];			%Commenting to check articulation computer

end

