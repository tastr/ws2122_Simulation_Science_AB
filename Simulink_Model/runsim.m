close all
clear all
clc
warning('off','all')

init_main
trials=100;

save_data=cell(1,trials);
set_param('main','SimMechanicsOpenEditorOnUpdate','off')
% set_param('main','SimMechanicsOpenEditorOnUpdate','on')
%%
for i = 1:trials
    t1 = intv*rand(1);
    musStart1 = 2*rand(1)-1;
    musEnd1 = 2*rand(1)-1;
    t2 = intv*rand(1);
    musStart2 = 2*rand(1)-1;
    musEnd2 = 2*rand(1)-1;

    out=sim('main');
    out.Muscle = [t1,musStart1,musEnd1,t2,musStart2,musEnd2];

    save_data{i}=out;
end
