# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.

"""
import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from scipy import interpolate
from numpy.linalg import inv

def LucasKanadeBasis(It,It1,rect,bases):
    
    dim1 = bases.shape[1]
    dim2 = bases.shape[0]
    bases=np.reshape(bases,(dim1*dim2,10)) 
    
    # Calculate gradient of template
  
    It = It[rect[1]:rect[3]+1, rect[0]:rect[2]+1]
    dx = np.gradient(It,axis=1)
    dy = np.gradient(It,axis=0)
    
    dx = np.expand_dims(dx.flatten('F'), axis=1)
    dy = np.expand_dims(dy.flatten('F'), axis=1)
    
    grad = np.concatenate((dx,dy),axis=1)
    
    # Value of Jacobian
    jacobian = np.array([[1, 0],[0, 1]])
    
    # Compute Steepest Descent
    steepest_desc = np.dot(grad,jacobian) - np.transpose(np.dot(np.transpose(np.dot(np.transpose(bases),grad)),np.transpose(bases)))
    
    # Compute Hessian
    hessian = np.dot(np.transpose(steepest_desc),steepest_desc)
    
    # Initialise u and v values
    
    u = 0
    v = 0
    thresh = 0.1
    change = 1
    
    while change > thresh: 
        # Perform image warping using interp2
        x_val = np.arange(rect[0]+u,rect[2]+1+u)
        y_val = np.arange(rect[1]+v,rect[3]+1+v)
        
        # Assert rectangle size
        x_val = x_val[:It.shape[1]]
        y_val = y_val[:It.shape[0]]
        
        
        size_1 = np.arange(It1.shape[0])
        size_2 = np.arange(It1.shape[1])
        interp_It1= interpolate.interp2d(size_2,size_1,It1)
        warped_It1 = interp_It1(x_val, y_val)
        
        # Calculate Error
        error=It - warped_It1
        error= error.flatten('F')
        
        temp1 = np.transpose(steepest_desc)
        val = np.dot(temp1,error)
        del_p = np.dot(inv(hessian),val)
        
        # Update parameters
        u = u+del_p[0]
        v = v+del_p[1]
        change = np.linalg.norm(del_p)
 
    return u,v


if __name__ == '__main__':
    # Load the data
    sylvseq = sio.loadmat('sylvseq.mat')
    sylvbases = sio.loadmat('sylvbases.mat')
    
    frame_data = sylvseq['frames']
    frames = frame_data.shape[2]
    bases = sylvbases['bases']
    
    # Initialise Rects matrix
    rects = np.zeros((frames,4))
    rects[0,:] = np.array([[101,61,155,107]])

    # Iterate over frames
    
    for x in range(0,frames-1):
        
        # Covert images to double (normlaize)
        It = frame_data[:,:,x].astype(np.float32)
        It = It /255.
        It1 = frame_data[:,:,x+1].astype(np.float32)
        It1 = It1/255.
        
        rect=rects[x,:].astype(int)
        
        # Call basis function
        [u, v] = LucasKanadeBasis(It,It1,rects[x,:].astype(int),bases)

        # Update rect coordinates
        rects[x+1,:] = [rects[x,0]+u, rects[x,1]+v, rects[x,2]+u, rects[x,3]+v];
        rects[x+1,:] = (np.around(rects[x+1,:], decimals = 0 )).astype(int)
    c=1
    
    # Plot images with tracker for each frame
    i = [2 ,100 ,200 ,300 ,400]
    count = 1
    a = plt.figure()
    for j in i:
        It = frame_data[:,:,j]
        ax = a.add_subplot(1,5,count)
        ax.imshow(It, cmap = 'gray')
        plt.axis('off')
        height = np.absolute(rects[j,0] - rects[j,2])
        width = np.absolute(rects[j,1] - rects[j,3])
        box = Rectangle((rects[j,0], rects[j,1]), height, width, edgecolor='r',facecolor='none')
        ax.add_patch(box)
        count = count + 1
    
    plt.show()