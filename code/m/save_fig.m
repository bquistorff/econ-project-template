function save_fig(base_fname)
h = openfig(strcat('fig/fig/',base_fname,'.fig'))

%normal PDF out put has huge borders
%http://stackoverflow.com/questions/5256516/matlab-print-a-figure-to-pdf-as-the-figure-shown-in-the-matlab
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf, 'PaperPosition',[0 0 screenposition(3:4)], 'PaperSize', [screenposition(3:4)]);

saveas(h, strcat('fig/pdf/',base_fname,'.pdf'))
title('')
saveas(h, strcat('fig/pdf/bare/',base_fname,'_bare.pdf'))

end