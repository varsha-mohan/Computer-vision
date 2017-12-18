
% load frames
load('aerialseq.mat');

% Get number of frames present
frame=size(frames,3);
masks=zeros(size(frames));

%Iterate over the number of frames
for i =1:(frame-1)
    
    % Load two consecutive images and obtain mask
    image1=frames(:,:,i);
    image2=frames(:,:,i+1);
	mask=SubtractDominantMotion(image1, image2);
    
    % Store the mask in a variable
	masks(:,:,i)=mask;
end
count=1;
% To display the required output for specific frames
for i = [30 60 90 120]
	mask= masks(:, :, i);
	C=imfuse(frames(:, :,  i), mask);
    subplot(1,4,count);
	imshow(C);
    title(i);
    count=count+1;
end
