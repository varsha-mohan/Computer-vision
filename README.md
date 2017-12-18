# Computer-vision

This consists of three sections. In the first section, the Inverse Compositional Lucas-Kanade (LK) tracker with one single template is implemented. The script testCarSequence.m demonstrates this. In order to further understand possible usage of this tracking algorithm, tracking a beating vessel in an ultrasound volume is carried out in testUltrasoundSequence.m

In the next portion of the assignment, appearance variation is taken into consideration and a variant of the Lucas-Kanade tracker is implemented. This is done in testSylvSequence.m where the toy Sylvester is tracked. 

In the final part of the assignment, a tracker for estimating dominant affine motion in a sequence of images, and subsequently identify pixels corresponding to moving objects in the scene is implemented. testAerialSequence.m allows the tracking of a moving object from an aerial view. 
