Project of the Universety of Stuttgart in subject "Data-Integrated Simulation Science A"
Based on https://github.com/daniel-haeufle/macroscopic-muscle-model and https://www.sciencedirect.com/science/article/pii/S0021929014001018. 
----------------------------------------------------------------------------------------

Needed libraries: Simscape, Simscape Multibody; 
Developer libraries (are included): Library_mtu_simulink and Muscles4SimScienceAB


The model can be initilized with the button ''Initilize me!'' or by running the script ''init_main''. 
The test input can be generated buy running test_input_data script. 

Intput from the own data can be generated as in load_data_and_sim_example

The model simulates a humanoid which tries to kick a ball into the wall. 

The model consists of:
- the world frame
- the model of the humanoid, which is illustrated from top to bottom 
- the floor model
- the wall model
- the ball model 
- the connections between the ball and the humanoid leg (upper, lower leg, and foot), as well as with the floor and the wall
- the input and output buses 

The upper body of the humanoid has no mass and aims only the visualisation. 

The lower body has two flexible legs, which have the hip, knee and the foot joints. The joints can be controlled via according input signals. 

The humanoid joints are simulated as mechanical joints driven by the muscle models (according to http://dx.doi.org/10.1016/j.jbiomech.2014.02.009)






