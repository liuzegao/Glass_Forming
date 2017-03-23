clear all; close all; clc;


cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])

load('TwoStatsModel_Refined.mat') 

n_c = zeros(1,9);
Si_simulation_ic = zeros(1,9);
Ca_simulation_ic = zeros(1,9);
BO_simulation_ic = zeros(1,9);
NBO_simulation_ic = zeros(1,9);
FO_simulation_ic = zeros(1,9);
N_TotalO_ic = zeros(1,9);

for  i_c = 1:9
switch(i_c)
    %FO_simulation_around_Ca+NBO_simulation_around_Ca
    case 2
        NBO_simulation_around_Ca =  3.366300366300366;
        FO_simulation_around_Ca =  0.0398351648351648;
    case 3
        NBO_simulation_around_Ca =  3.997774810858923;
        FO_simulation_around_Ca =  0.018469069870939;
    case 4
        NBO_simulation_around_Ca =  4.357855717137154;
        FO_simulation_around_Ca =  0.061305959509552;
    case 5
        NBO_simulation_around_Ca =  4.566584209441352;
        FO_simulation_around_Ca = 0.332508761080190;
    case 6
        NBO_simulation_around_Ca =  4.649761904761904;
        FO_simulation_around_Ca = 0.456587301587302;
    case 7
        NBO_simulation_around_Ca =  4.710730158730159;
        FO_simulation_around_Ca = 0.672317460317460;
    case 8
        NBO_simulation_around_Ca =  4.165780973220798;
        FO_simulation_around_Ca = 1.465666354068980;
    case 9
        NBO_simulation_around_Ca =  2.911620795107034;
        FO_simulation_around_Ca = 2.864307557885540;
end


Total_Atom = Si_simulation(i_c)+Ca_simulation(i_c)+BO_simulation(i_c)+NBO_simulation(i_c)+FO_simulation(i_c);
N_TotalO_ic(1,i_c) = BO_simulation(i_c)+NBO_simulation(i_c)+FO_simulation(i_c) ;
Si_simulation_ic(1,i_c) = Si_simulation(i_c);
Ca_simulation_ic(1,i_c) = Ca_simulation(i_c);
BO_simulation_ic(1,i_c) = BO_simulation(i_c);
NBO_simulation_ic(1,i_c) = NBO_simulation(i_c);
FO_simulation_ic(1,i_c) = FO_simulation(i_c);
if i_c ~= 1
n_c(1,i_c) = Si_simulation(i_c)/Total_Atom*9+BO_simulation(i_c)/Total_Atom+(FO_simulation_around_Ca+NBO_simulation_around_Ca)*Ca_simulation(i_c)/Total_Atom;
end
display(i_c);
end
n_c(1,1) = 3;

figure(1)
i = 1:1:9;
i = (i-1)*10;
y1 = zeros(9);
y2 = zeros(9);
for k =1:1:9
    y1(k) = 3-0.05;
    y2(k) = 3+0.05;
end
plot(i,n_c,'-bs',i,y1,'--r',i,y2,'--g')
title('\fontsize{16}Number of Constraints per Atom vs Ca Composition','Fontsiz',12);
xlabel('x(Ca %)','Fontsiz',12,'fontweight','bold');
ylabel('nc','Fontsiz',12,'fontweight','bold' );
axis([0 80 2.8 3.7]);io

figure(2)
plot(i,BO_simulation_ic./N_TotalO_ic,i,NBO_simulation_ic./N_TotalO_ic,i,FO_simulation_ic./N_TotalO_ic,'LineWidth',1);
legend({'BO','NBO','FO'},'FontSize',12,'fontweight','bold');
xlabel('x(Ca %)','Fontsiz',12,'fontweight','bold');
ylabel('Ratio','Fontsiz',12,'fontweight','bold');
title('\fontsize{16}Oxygen Species Ratio vs Ca Composition','Fontsiz',12);


