clear all; close all; clc;

if ispc   
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])
else
    %/Users/zegaoliu/Dropbox/CS Glasses/C80S20
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB']) 
end

load('TwoStatsModel_Revised.mat') 

n_c = zeros(1,9);
Si_simulation_ic = zeros(1,9);
Ca_simulation_ic = zeros(1,9);
BO_simulation_ic = zeros(1,9);
NBO_simulation_ic = zeros(1,9);
FO_simulation_ic = zeros(1,9);
N_TotalO_ic = zeros(1,9);

    if ispc   
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab/All_O_around_per_Ca'])
    else
    %/Users/zegaoliu/Dropbox/CS Glasses/C80S20
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/Glass_Forming_Matlab/All_O_around_per_Ca']) 
    end
     data_simulation= dlmread('BO_NBO_FO_around_Ca.txt');
for  i_c = 1:9
if i_c ~= 1
        NBO_simulation_around_Ca =  data_simulation(1,i_c-1);    
        BO_simulation_around_Ca =  data_simulation(2,i_c-1);
        FO_simulation_around_Ca = data_simulation(3,i_c-1);
end
Total_Atom = Si_simulation(i_c)+Ca_simulation(i_c)+BO_simulation(i_c)+NBO_simulation(i_c)+FO_simulation(i_c);
N_TotalO_ic(1,i_c) = BO_simulation(i_c)+NBO_simulation(i_c)+FO_simulation(i_c) ;
Si_simulation_ic(1,i_c) = Si_simulation(i_c);
Ca_simulation_ic(1,i_c) = Ca_simulation(i_c);
BO_simulation_ic(1,i_c) = BO_simulation(i_c);
NBO_simulation_ic(1,i_c) = NBO_simulation(i_c);
FO_simulation_ic(1,i_c) = FO_simulation(i_c);
if i_c ~= 1
n_BS(i_c) = (4*Si_simulation(i_c)+Ca_simulation(i_c)*(FO_simulation_around_Ca+NBO_simulation_around_Ca))/Total_Atom;
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
hold on 
p1 = plot(i,n_c,'-bs');
plot(i,y1,'--r',i,y2,'--g')
title('\fontsize{16}Number of Constraints per Atom vs Ca Composition','Fontsiz',12);
xlabel('x(Ca %)','Fontsiz',12,'fontweight','bold');
ylabel('nc','Fontsiz',12,'fontweight','bold' );
axis([0 80 2.6 3.8]);





if ispc   
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])
else
    %/Users/zegaoliu/Dropbox/CS Glasses/C80S20
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB']) 
end


load('TwoStatsModel_Revised_2500K.mat');

n_c = zeros(1,9);
n_BS = zeros(1,9);
n_BB = zeros(1,9);
Si_simulation_ic = zeros(1,9);
Ca_simulation_ic = zeros(1,9);
BO_simulation_ic = zeros(1,9);
NBO_simulation_ic = zeros(1,9);
FO_simulation_ic = zeros(1,9);
N_TotalO_ic = zeros(1,9);

    if ispc   
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab/All_O_around_per_Ca'])
    else
    %/Users/zegaoliu/Dropbox/CS Glasses/C80S20
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/Glass_Forming_Matlab/All_O_around_per_Ca']) 
    end
     data_simulation= dlmread('BO_NBO_FO_around_Ca_2500K.txt');
     
for  i_c = 1:9
if i_c ~= 1
        NBO_simulation_around_Ca =  data_simulation(1,i_c-1);    
        BO_simulation_around_Ca =  data_simulation(2,i_c-1);
        FO_simulation_around_Ca = data_simulation(3,i_c-1);
end

Total_Atom = Si_simulation(i_c)+Ca_simulation(i_c)+BO_simulation(i_c)+NBO_simulation(i_c)+FO_simulation(i_c);
N_TotalO_ic(1,i_c) = BO_simulation(i_c)+NBO_simulation(i_c)+FO_simulation(i_c) ;
Si_simulation_ic(1,i_c) = Si_simulation(i_c);
Ca_simulation_ic(1,i_c) = Ca_simulation(i_c);
BO_simulation_ic(1,i_c) = BO_simulation(i_c);
NBO_simulation_ic(1,i_c) = NBO_simulation(i_c);
FO_simulation_ic(1,i_c) = FO_simulation(i_c);
if i_c ~= 1
n_BS(i_c) = (4*Si_simulation(i_c)+Ca_simulation(i_c)*(FO_simulation_around_Ca+NBO_simulation_around_Ca))/Total_Atom;
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
p2 =plot(i,n_c,'-ms');
plot(i,y1,'--r',i,y2,'--g');
title('\fontsize{16}Number of Constraints per Atom vs Ca Composition 300K &¡¡2500K','Fontsiz',12);
xlabel('x(Ca %)','Fontsiz',12,'fontweight','bold');
ylabel('nc','Fontsiz',12,'fontweight','bold' );
axis([0 80 2.5 3.8]);

legend([p1 p2],'300k','2500k')

hold off
%{
figure(2)
plot(i,BO_simulation_ic./N_TotalO_ic,i,NBO_simulation_ic./N_TotalO_ic,i,FO_simulation_ic./N_TotalO_ic,'LineWidth',1);
legend({'BO','NBO','FO'},'FontSize',12,'fontweight','bold');
xlabel('x(Ca %)','Fontsiz',12,'fontweight','bold');
ylabel('Ratio','Fontsiz',12,'fontweight','bold');
title('\fontsize{16}Oxygen Species Ratio vs Ca Composition','Fontsiz',12);
%}
