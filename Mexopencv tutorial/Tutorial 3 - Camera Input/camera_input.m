% Connect to a camera
clear all;
camera = cv.VideoCapture(0); % try -1, 0, 1, 2, 3
pause(2);
decode_option = ['D', 'I', 'V', 'X'];
vid = cv.VideoWriter('myvideo.avi', [640,480], 'fourcc', decode_option);
for i = 1:50000
    % Capture and show frame
    frame = camera.read;
    imshow(frame);
    vid.write(frame);
    pause(0.01);
end