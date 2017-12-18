function [u,v] = LucasKanadeBasis(It, It1, rect, bases)

% input - image at time t, image at t+1, rectangle (top left, bot right
% coordinates), bases 
% output - movement vector, [u,v] in the x- and y-directions.
bases=reshape(bases,size(bases,1)*size(bases,2),10);
% Convert images to double
It=im2double(It);
It1=im2double(It1);

% Get rect coordinates and apply on image
y=rect(2):rect(4);
x=rect(1):rect(3);

% Calculate gradient of template
It=It(y,x);
[dx,dy]=gradient(double(It));

dx=dx(:);
dy=dy(:);

% Value of Jacobian
jacobian=[1 0;0 1];
% Compute steepest descent images
steepest_desc=[dx dy]*jacobian-((bases'*[dx dy])'*bases')';

% Compute the inverse hessian matrix
hessian=(steepest_desc')*steepest_desc;

% Initialise u and v and also the threshold
u=0;
v=0;
thresh=0.1;
change=1;
% Condition for updation
while change>thresh
    
    % Perform image warping using interp2
    x_val=rect(1,1)+u:rect(1,3)+u;
    y_val=rect(1,2)+v:rect(1,4)+v;
    [X,Y]=meshgrid(x_val,y_val);
    warped_It1=interp2(It1,X,Y);
    
    % Compute error image
    error=(It-warped_It1);
    error=error(:);
    
    val=(steepest_desc)'*error;
    del_p=(hessian)\val;
    
    % Update the warp
    u=u+del_p(1);
    v=v+del_p(2);
    
    change=norm(del_p);
    
end
u=u;
v=v;
end