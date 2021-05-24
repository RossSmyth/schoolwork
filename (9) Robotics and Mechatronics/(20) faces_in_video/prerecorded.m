%% Detect and track faces in video frames
% Ross Smyth
clc, clear, close all

% Create a detector object.
faceDetector = vision.CascadeObjectDetector(); 

% Read input video
videoReader = VideoReader('visionface.avi');

% Video player for output
videoPlayer  = vision.VideoPlayer;

%% Detect faces. 
while hasFrame(videoReader)
    % Get next frame
    frame = readFrame(videoReader);
    
    % Calculate bounding box
    bboxes = step(faceDetector, frame);
    
    % Annotate fram with bounding box
    videoOut = insertObjectAnnotation(frame,'rectangle',bboxes,'Face');
    
    % Output to player
    step(videoPlayer, videoOut)
end

% Free player resoruces
release(videoPlayer)