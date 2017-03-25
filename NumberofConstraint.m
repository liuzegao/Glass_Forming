clear all; close all; clc;


cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])

load('TwoStatsModel_Revised.mat') 

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
        BO_simulation_around_Ca = 1.610805860805861;
        FO_simulation_around_Ca = 0.197344322344322;
    case 3
        BO_simulation_around_Ca = 1.154899602109744;
        FO_simulation_around_Ca =  0.233691126121958;
    case 4
        BO_simulation_around_Ca = 1.064585115483319;
        FO_simulation_around_Ca = 0.267179925862561;
    case 5
        BO_simulation_around_Ca =  0.791907762204792;
        FO_simulation_around_Ca = 0.336783678367837;
    case 6
        BO_simulation_around_Ca =  0.581666666666667;
        FO_simulation_around_Ca = 0.418650793650794;
    case 7
        BO_simulation_around_Ca =  0.287682539682540;
        FO_simulation_around_Ca = 0.653523809523810;
    case 8
        BO_simulation_around_Ca =  0.084557674273210;
        FO_simulation_around_Ca = 1.462592476815672;
    case 9
        BO_simulation_around_Ca =  0.010528615115771;
        FO_simulation_around_Ca = 3.010135430318917;
end



Total_Atom = Si_simulation(i_c)+Ca_simulation(i_c)+BO_simulation(i_c)+NBO_simulation(i_c)+FO_simulation(i_c);
N_TotalO_ic(1,i_c) = BO_simulation(i_c)+NBO_simulation(i_c)+FO_simulation(i_c) ;
Si_simulation_ic(1,i_c) = Si_simulation(i_c);
Ca_simulation_ic(1,i_c) = Ca_simulation(i_c);
BO_simulation_ic(1,i_c) = BO_simulation(i_c);
NBO_simulation_ic(1,i_c) = NBO_simulation(i_c);
FO_simulation_ic(1,i_c) = FO_simulation(i_c);
if i_c ~= 1
n_BS(i_c) = (4*Si_simulation(i_c)+4*Ca_simulation(i_c)*(FO_simulation_around_Ca+BO_simulation_around_Ca))/Total_Atom;
n_BB(i_c) = (5*Si_simulation(i_c)+BO_simulation(i_c))/Total_Atom;
n_c(1,i_c) = n_BS(i_c)+n_BB(i_c);
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
axis([0 80 2.5 5.5]);


figure(2)
plot(i,n_BB,'-s',i,n_BS,'-s')
title('\fontsize{16}Number of BB Constraints per Atom vs Ca Composition','Fontsiz',12);
xlabel('x(Ca %)','Fontsiz',12,'fontweight','bold');
ylabel('nBB','Fontsiz',12,'fontweight','bold' );
legend('BB','BS')