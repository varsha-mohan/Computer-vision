% load frames
load('usseq.mat');
frame=size(frames,3);

% Initialise the rects matrix
rects=zeros(frame,4);
rects(1,:)=[255,105,310,170];


% Iterate over number of frames present
for i=1:(frame-1)
    
    % Convert image to double. 
    It=im2double(frames(:,:,i));
    
    %Load the next image and calculate u and v
    It1=im2double(frames(:,:,i+1));
    [u,v] = LucasKanadeInverseCompositional(It, It1, rects(i,:));
    
    % Update the rect coordinates and store it
    rects(i+1,:)=[rects(i,1)+u rects(i,2)+v rects(i,3)+u rects(i,4)+v];
    rects(i+1,:)=round(rects(i+1,:));
   
	
        

end


% To display the tracking efficiency
c=1;
for i = [5 25 50 75 100]
It=im2double(frames(:,:,i));
subplot(1,5,c);
imshow(It);
title(i);
hold on;
rectangle('Position',[rects(i,1),rects(i,2),abs(rects(i,1)-rects(i,3)),abs(rects(i,2)-rects(i,4))],'EdgeColor','r');
hold off;
c=c+1;
end

% save the rects
save usseqrects.mat rects