motion_detection_project();
%main function that will run all 4 algorithms
function motion_detection_project()

frame_folders = ['ArenaA','ArenaN','AShipDeck','getin','getout','movecam','trees','walk'];

%here we will call run_algorithms in a loop, iterating through each
%directory in the frame_folders. After getting the results, it will the end
%of the loop will take the result matrix and export it as the 4 panel image
%needed for that frame for the video

%send directory to func
%for i = 1:size(frame_folders,2)
%run_algorithms
run_algorithms('walk');

end

function final = run_algorithms(frame_dir)
%this function will go through a directory frame by frame
%it will read in every frame from the directory, and pass the frame to each
%algorithm, then return a matrix containing the 4 images from each
%algorithm
vid_frames = dir(fullfile(frame_dir, '*.jpg'));

sub_base = imread(strcat(frame_dir,'/f0001.jpg'));
g_sub_base = rgb2gray(sub_base); %grayscale base

for frame = 2:length(vid_frames)
    
    %Get the file name for the current frame
    file_name = vid_frames(frame).name;
    %Get the full file path for the current frame
    full_frame_path = fullfile(frame_dir, file_name);
    
    %read in the current frame and convert to grayscale
    current_frame = imread(full_frame_path);
    gray_current = rgb2gray(current_frame);
    
    %%%SIMPLE BACKGROUND SUBSTITUTION 
    %Run simple background subtraction
    M_simple_sub = simple_background_subtraction(gray_current, 70,g_sub_base);
    
    %%%SIMPLE FRAME DIFFERENCING
    %Get the previous frame
    prev_file = vid_frames(frame-1).name;
    %Get the full file path for the previous frame
    full_prev_frame_path = fullfile(frame_dir, prev_file);
    %read in the previous frame and convert to grayscale
    prev_frame = imread(full_prev_frame_path);
    g_prev_frame = rgb2gray(prev_frame);
    
    %Run simple frame differencing
    M_simple_diff = simple_frame_differencing(gray_current, g_prev_frame, 70);
    
    %%%ADAPTIVE BACKGROUND SUBTRACTION
    alpha = 0.5;
    
    
    
    %M_adaptive_background = adaptive_background_subtraction(full_frame_path, threshold, alpha_val)
    
    
    %%%PERSISTENT FRAME DIFFERENCING
    %M_persistent_frame = persistent_frame_differencing(full_frame_path, threshold, gamma_val)
    
    
    %This code will output the 4 panel image into a folder frame by frame
    %final = [M_simple_sub, M_simple_diff; M_adaptive_background,M_persistent_frame]
    final = [M_simple_sub,M_simple_diff];
    new_file = strcat('new_walk',file_name); %This needs to be fixed to dynamically output the new frame images based on the current directory
    imwrite(final, new_file);
end

end

%function for simple background subtraction
function M_subtract = simple_background_subtraction(g_current_frame, threshold, base)
    diff = abs(base - g_current_frame);
    M_subtract = diff > threshold;
end

%function for simple frame differencing
%This is working, however some back edges are not showing... consider maybe
%playing with this by doing the grayscaling the way he has it in bobtips
%pdf
function M_diff = simple_frame_differencing(g_current_frame, g_prev_frame, threshold)
    diff = abs(g_prev_frame - g_current_frame);
    M_diff = diff > threshold;
end

%function for adaptive background subtraction
function M_adapt = adaptive_background_subtraction(full_frame_path, full_prev_frame_path, threshold)
    diff = abs(g_prev_frame - g_current_frame);
    M_adapt = diff > threshold;
end

%function for persistent frame differencing
function M_persist = persistent_frame_differencing(frame, threshold, gamma_val)




end