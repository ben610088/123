clc,clear,close
run('PreLoadFcn.m')

mdl = 'example_main_NDI_f16'

tic
sim(mdl, [0 75])
toc
show_response
