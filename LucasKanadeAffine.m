function M = LucasKanadeAffine(It, It1)

% input - image at time t, image at t+1 
% output - M affine transformation matrix

% Convert images to double
It=im2double(It);
It1=im2double(It1);

% Calculate gradient of template
[dx,dy]=gradient(It);

dx=dx(:);
dy=dy(:);


[X,Y]=meshgrid(1:size(It,2),1:size(It,1));
X=X(:);
Y=Y(:);

% Calculate Steepest descent

steepest_desc=[X.*dx X.*dy Y.*dx Y.*dy dx dy];

p=[0;0;0; 0;0;0];
i=0;
while i<100
    i=i+1;
    M=[1+p(1) p(3) p(5);p(2) 1+p(4) p(6);0 0 1];
    warp=M*[X(:)';Y(:)';ones(1,numel(It))];
    common_region=(warp(1,:)>=1) & (warp(1,:)<size(It1,2)) & (warp(2,:)>=1) & (warp(2,:)<size(It1,1));
    new_steepestdesc=steepest_desc(common_region,:);
    
    warped_It1=interp2(It1,warp(1,:),warp(2,:),'nearset');
    
    % Calculate Error
    error=It(:)'-warped_It1;
    error=error(common_region);
    
    del_p=(new_steepestdesc'*new_steepestdesc)\(new_steepestdesc'*error(:));
    
    p=p+del_p;
    
    if (norm(del_p)<=0.1)
		break;
    end
end
end