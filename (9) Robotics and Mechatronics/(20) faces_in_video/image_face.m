clear, clc, close all
% Ross Smyth
% Week 10 MEEM Robotics and Mechatronics
% Real-time, live, webcam face tracking

% This uses the classic concurrent model of processing, producer consumer
% The producer is the getImage function.
% The consumer is the processImage function.
% They are joined with a queue
% This is designd to only track a single face

% Requires the vision toolbox and parrallel toolbox.
%% Parameters

% Data gathering parameters
FPS     = 10; % frames per second
runTime = 10; % seconds

%% Setup
% Checks to see if there are any event loops running. Starts one if not.
if isempty(gcp("nocreate"))
    parpool('local');
end

% init struct for calculating data
faceTrack.detector   = vision.CascadeObjectDetector(); % Facial detection
faceTrack.tracker    = vision.PointTracker(); % point tracker
faceTrack.player     = vision.VideoPlayer(); % Video player
faceTrack.points     = []; % Points to track
faceTrack.prevPoints = []; % Previous points
faceTrack.bboxPoints = []; % Bounding box points

% Set max error to 2 so points are binned
faceTrack.tracker.MaxBidirectionalError = 2;

% Create queue to push data to
imageQueue = parallel.pool.DataQueue;

% Whenever data is in the queue, process it
afterEach( imageQueue, @(image) processImage(image, faceTrack) );

% Start the task
f = parfeval(@getImage, 0, imageQueue, FPS);

pause(runTime) % Run for runTime
cancel(f)  % End after runTime expires

function getImage(imageQueue, FPS)
    % Uses the default camera
    cam = webcam;
    
    while true
        % Get an image
        image = snapshot(cam);
        
        % Send to queue
        send(imageQueue, image)
        
        % Sleep until next frame sample
        pause(1/FPS);
    end
    
end

function processImage(image, faceTrack)
    persistent trackStruct % PErsists between calls so it doesn't clear when goes out of scope
    if isempty(trackStruct)
        trackStruct = faceTrack; % First run, init with data
    end
    
    grayImage = rgb2gray(image); % Convert to greyscale for slightly faster computation
    
    if size(trackStruct.points, 1) < 10
        % Detect a face
        bbox = trackStruct.detector(image);
        
        if ~isempty(bbox)
            % If a face is found, identify points to track
            trackStruct.points = detectMinEigenFeatures(grayImage, 'ROI', bbox(1, :));
            
            % Reinitilise the point tracker for the new points
            trackStruct.points = trackStruct.points.Location;
            release(trackStruct.tracker);
            initialize(trackStruct.tracker, trackStruct.points, grayImage);
            
            % Set the prvious poitns for the next frame
            trackStruct.prevPoints = trackStruct.points;
            
            % Convert to be able to be transformed
            trackStruct.bboxPoints = bbox2points(bbox(1, :));
            
            % Polygon to annotate
            bbox = reshape(trackStruct.bboxPoints', 1, []);
            
            % Annotate the image with bbox and points
            image = insertShape(image, 'Polygon', bbox, 'LineWidth', 3);
            image = insertMarker(image, trackStruct.points, '+', 'Color', 'white');
        end
    
    else
        % Track points and only track visible ones
        [trackStruct.points, isFound] = trackStruct.tracker(grayImage);
        trackStruct.points            = trackStruct.points(isFound, :);
        trackStruct.prevPoints        = trackStruct.prevPoints(isFound, :);  
        
        if size(trackStruct.points, 1) >= 10
            % Estimate transformation and only track those that their
            % transformations can be estimated
            [transform, inlierIndexes] = estimateGeometricTransform2D(trackStruct.prevPoints, trackStruct.points, 'similarity', 'MaxDistance', 4);
            trackStruct.prevPoints = trackStruct.prevPoints(inlierIndexes, :);
            trackStruct.points     = trackStruct.points(inlierIndexes, :);
            
            % Transform bbox by the point estimation
            trackStruct.bboxPoints = transformPointsForward(transform, trackStruct.bboxPoints);
            
            % Polygon to annotate
            bbox = reshape(trackStruct.bboxPoints', 1, []);
            
            % Annotate the image
            image = insertShape(image, 'Polygon', bbox, 'LineWidth', 3);
            image = insertMarker(image, trackStruct.points, '+', 'Color', 'white');
            
            % Set the current points as the prev for next frame
            trackStruct.prevPoints = trackStruct.points;
            setPoints(trackStruct.tracker, trackStruct.prevPoints);
        end
    end
            
    % insert to player
    trackStruct.player(image);
end
    