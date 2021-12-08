tend = 1;
t = 0:Ts:tend;
N = length(t);

dataset.uhipx = timeseries([ones((N-1)/2,1); zeros((N-1)/2 + 1,1)], t, 'Name', 'uhipx');
dataset.uhipy = timeseries([zeros(N,1)], t, 'Name', 'uhipy');


InputData = Simulink.Bus.createObject(dataset)
InputData.busName = 'InputData'



