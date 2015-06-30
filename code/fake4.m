%Header
run('setup_m_path.m')

log_open('fake4')
echo on %show commands along with the output (helpful for logging)
run('m_project_base.m')


%Content
x = 0:pi/100:2*pi;
y = sin(x);
save('../data/generated/fake4.mat','x')
plot(x,y)
title('new title')
savefig('../fig/fig/fake4.fig')

log_close()