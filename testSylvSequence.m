% load frames
load('sylvseq.mat');
load('sylvbases.mat');
frame=size(frames,3);

% Initialise the rects matrix
rects=zeros(frame,4);
rects(1,:)=[102,62,156,108];


% Iterate over number of frames present
for i=1:(frame-1)
    
    % Convert image to double. Hold image and construct the rectangle
    It=im2double(frames(:,:,i));
    
    %Load the next image and calculate u and v
    It1=im2double(frames(:,:,i+1));
    [u,v] = LucasKanadeBasis(It, It1, rects(i,:),bases);
    
    % Update the rect coordinates and store it
    rects(i+1,:)=[rects(i,1)+u rects(i,2)+v rects(i,3)+u rects(i,4)+v];
    rects(i+1,:)=round(rects(i+1,:));
    
    
end

% To display the tracking efficiency
c=1;
for i = [2 200 300 350 400]
It=im2double(frames(:,:,i));
subplot(1,5,c);
imshow(It);
title(i);
hold on;
rectangle('Position',[rects(i,1),rects(i,2),abs(rects(i,1)-rects(i,3)),abs(rects(i,2)-rects(i,4))]);
hold off;
c=c+1;
end




% save the rects
save sylvseqrects.mat rects