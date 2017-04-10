clear all; close all; clc;

if ispc   
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])
else
    %/Users/zegaoliu/Dropbox/CS Glasses/C80S20
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB']) 
end

load('Ca_Coordination_Number.mat')


hold on;

i = 2:1:9;
i = (i-1)*10;
AO = NBO_around_per_Ca+BO_around_per_Ca+FO_around_per_Ca;
figure(1)
plot(i,NBO_around_per_Ca,'-*b',i,BO_around_per_Ca,'-*g',i,FO_around_per_Ca,'-*r',i,AO,'-*m',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerFaceColor',[0.5,0.5,0.5])
title('Ca Coordination Number of BO, NBO and FO vs Ca Composition');
xlabel('x(Ca %)');
ylabel('BO, NBO and FO Around Each Ca' );




if ispc   
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])
else
    %/Users/zegaoliu/Dropbox/CS Glasses/C80S20
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB']) 
end

load('Ca_Coordination_Number_2500K.mat')


hold on;

i = 2:1:9;
i = (i-1)*10;
AO = NBO_around_per_Ca+BO_around_per_Ca+FO_around_per_Ca;
figure(1)
 plot(i,NBO_around_per_Ca,'-.ob',i,BO_around_per_Ca,'-.og',i,FO_around_per_Ca,'-.or',i,AO,'-.om',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerFaceColor',[0.5,0.5,0.5])
title('Ca Coordination Number of BO, NBO and FO vs Ca Composition');
xlabel('x(Ca %)');
ylabel('BO, NBO and FO Around Each Ca' );
legend('NBO','BO','FO','All O','NBO 2500K','BO 2500K','FO 2500K','All O 2500K');

hold off;


