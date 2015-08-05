%Header
setup_m_path

log_open('fake4')
echo on %show commands along with the output (helpful for logging)
m_project_base

%Content
x = 0:pi/100:2*pi;
y = sin(x);
save('data/generated/fake4.mat','x')
plot(x,y)
title('new title')
wr_save_fig('fake4')

t=0:900;
plot(t,0.25*exp(-0.005*t))
xlabel('-2\pi < x < 2\pi')
ylabel('sine and cosine values')
title('The title')
long_note = 'hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi';
wr_save_fig('fake4b',long_note)

log_close()