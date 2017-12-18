function mask = SubtractDominantMotion(image1, image2)

% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size

image1=im2double(image1);
image2=im2double(image2);

[m,n]=size(image1);
[f,g]=size(image2);
% Calculate M matrix value
M = LucasKanadeAffine(image1, image2);


[dx,dy] = meshgrid(1:n,1:m);
warp=M*[dx(:)'; dy(:)';ones(1,numel(image1))];

common_region=(warp(1,:)>=1) & (warp(1,:)<= size(image2,2)) & (warp(2,:)>=1) & (warp(2,:)<=size(image2,1));

warped_img=warpH(image1,M,[f g]);
error=image2(:)-warped_img(:);


common_region=common_region(:) & (error(:)>0.1);
mask=reshape(common_region,[m,n]);


end