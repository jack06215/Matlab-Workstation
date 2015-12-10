% Connect to a camera
clear all;
camera = cv.VideoCapture('Sample Images\MAH00019.avi'); % try -1, 0, 1, 2, 3
pause(2);
%decode_option = ['D', 'I', 'V', 'X'];
%vid = cv.VideoWriter('myvideo.avi', [640,480], 'fourcc', decode_option);
for i = 1:10
    % Capture and show frame
    frame = camera.read;
    frameCpy = frame;
    gray = cv.cvtColor(frame, 'RGB2GRAY');
    imshow(frame);
    %vid.write(frame);
    pause(0.01);
end