clear; close all; clc;

if ispc
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])
else
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])
end
 
load('TwoStatsModel_Revised.mat') 

figure(1)
hold on
i = 1:1:9;
i = (i-1)*10;
plot(i,NBOratio_simulation,'-.*r',i,BOratio_simulation,'-.*k',i,FOratio_simulation,'-.*b',... 
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerFaceColor',[0.5,0.5,0.5]);


%% Input Data 2500K %%
clear all;

if ispc
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])
else
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])
end
    
load('TwoStatsModel_Revised_2500K.mat') 

i = 1:1:9;
i = (i-1)*10;
plot(i,NBOratio_simulation,'-*r',i,BOratio_simulation,'-*k',i,FOratio_simulation,'-*b',... 
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerFaceColor',[0.5,0.5,0.5]);
axis([0 80 0 1]);
title('NBO,BO,FO Ratio vs Composition 300K,2500K','fontsize',16,'fontweight','bold');
xlabel('x(Ca %)','fontsize',14);
ylabel('OxygenType/Numer of O' ,'fontsize',14);
legend('NBO simulation 300K','BO simulation 300K','FO simulation 300K','NBO simulation 2500k','BO simulation 2500k','FO simulation 2500k','fontweight','bold');
hold off;