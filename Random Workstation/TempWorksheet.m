video = vision.VideoFileReader('Sample Images\MAH00019.avi');
while ~isDone(video);
    TempFrame = im2uint8(step(video));
end