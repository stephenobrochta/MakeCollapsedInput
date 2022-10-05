% This examples uses Core F-7 from the following paper:
% 
% Osamu Fujiwara, Toshiaki Irizuki, Stephen P. Obrochta, Yoshikazu Sampei, Akira Tomotsuka, Ayumi Haruki,
% Occurrence mode of Holocene tsunami overwash controlled by the geomorphic development along the eastern Nankai Trough, central Japan,
% Quaternary Science Reviews,
% Volume 292,
% 2022,
% 107639,
% ISSN 0277-3791,
% https://doi.org/10.1016/j.quascirev.2022.107639.

% The agemodel will be "F-7_input-reexpanded_admodel.pdf" and "F-7_input-reexpanded_admodel.txt"

% top and bottom depths of event layers
Events = 'F-7_events.xlsx';

% A standard Undatable input file and parameters
inputfile = 'F-7_input.xlsx';
nsim = 10^4;
bootpc = 30;
xfactor = 0.1;

% make and save a new input file using a collapsed depthscale (intervals of events removed)
[Collapsed,Events,Uncollapsed] = MakeCollapsedInput(Events,inputfile);

% Create an age model for the collapsed scale
inputfile = strrep(inputfile,'.xlsx','-collapsed.txt');
undatable(inputfile,nsim,xfactor,bootpc,'savemat',1,'vcloud',1,'plotme',0,'printme',0);

% add back in the thickness of the events
ReExpand(strrep(inputfile,'.txt','.mat'));