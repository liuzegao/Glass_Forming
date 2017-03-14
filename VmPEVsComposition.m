clear;clc;close all


%%Constants
NA = 6.02214*10^(23);

%% Molar Volume vs. Ca Composition
% Column 5 -> Volume  

MolarVolume = zeros(1,9);
Vm = zeros (1,9);

user = input('User is ','s');

for i = 1:9
    cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i-1)*10),'S',num2str((11-i)*10)]);
   
    Thermodata = dlmread('thermo_cooling.dat');
    MolarVolume(i) =Thermodata(end,5);                        %Volume given by lammps
    Vm(i)= MolarVolume(i)/(3000) * NA * (3-i/10) * (10^-8)^3;  %Convert to true molar volume
end

x=0:1:8;
figure(1);
plot (x, Vm,'-');
title('Molar Volume at 300K vs Ca Composition');
xlabel('x(10%)');
ylabel('Volume (cm^-3)/mole' );

%% PE vs. Ca Composition
% Column 3 -> Volume  

PE_lammps= zeros(1,9);
PE = zeros (1,9);

for i = 1:9
    cd (['/Users/vickihuuu/Dropbox/CS Glasses/C',num2str((i-1)*10),'S',num2str((11-i)*10)]);
   
    Thermodata = dlmread('thermo_cooling.dat');
    PE_lammps(i) =Thermodata(end,3);                           %PE given by lammps
    PE(i)= MolarVolume(i)/NA * 4.184 / (3000) * NA * (3-i/10);  %Convert to molar PE
end

x=0:1:8;
figure(2);
plot (x, PE,'-');
title('Molar PE at 300K vs Ca Composition');
xlabel('x(10%)');
ylabel('PE (KJ/mole)' );