clear;clc;close all


%%Constants
NA = 6.02214*10^(23);

%% Density vs. Ca Composition
% Column  -> density Column 2 -> T 


AvgDensity = zeros(1,6);

for i = 1:9
    cd (['/Users/vickihuuu/Dropbox/CS Glasses/C',num2str((i-1)*10),'S',num2str((11-i)*10)])
    %% cd(['/Users/zegaoliu/Dropbox/CS Glasses/C',num2str((i-1)*10),'S',num2str((11-i)*10)])
    Thermodata = dlmread('thermo_cooling.dat');
    AvgDensity(i)=mean(Thermodata((end-1):end,6));
end
    x=0:1:8;
    figure(1);
    plot(x,AvgDensity,'-o');
    title('Density vs Ca Composition')
    xlabel('x(10%)')
    ylabel('Density (g/cm^-3)' )
    
%% PE vs. Ca Composition
% Column 6 -> density Column 2 -> T  Column 3 -> PE


AvgPE = zeros(1,6);

for i = 1:9
    cd (['/Users/zegaoliu/Dropbox/CS Glasses/C',num2str((i-1)*10),'S',num2str((11-i)*10)])
    Thermodata = dlmread('thermo_cooling.dat');
    AvgPE(i)=mean(Thermodata((end-1):end,3))/NA*4.184/3000*NA*(3-(i-1)*0.1);
    % i is from 1-7 while x is from 0.0 to 0.6
    % U_m = U_lammps/ NA * 4.184 / (# of atoms in simulation) * NA * (3-x)
end
    x=0:1:8;
    figure(2);
    plot(x,AvgPE,'-o');
    title('PE vs Ca Composition')
    xlabel('x(10%)')
    ylabel('PE (kJ/mole)' )