clear; clc; close all

user = input('User is ','s');

%i = input('Ca Composition is % ')/10+1;

V_avg_i = zeros(1,9);
V_std_i = zeros(1,9);
PE_avg_i = zeros(1,9);
PE_std_i = zeros(1,9);

for i = 1:9
NA = 6.022*10^23;

cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i-1)*10),'S',num2str((11-i)*10)]);

%range= [4204 1 (4204+100) 8];  4204-4304  Relaxation 
data = dlmread('cooloutput.txt');

data(:,7)= data(:,7)/(3000) * NA * (3-i/10) * (10^-8)^3; %Convert to true molar volume
V_avg = mean(data(4204:4304,7));
V_std = std(data(4204:4304,7));
V_avg_i(i) = V_avg;
V_std_i(i) = V_std;

% 4305-4516

data(:,5)= data(:,5)/NA * 4.184 / (3000) * NA * (3-i/10);  %Convert to true molar PE
PE_avg = mean(data(4416:4516,5));
PE_std = std(data(4416:4516,5));
PE_avg_i(i) = PE_avg;
PE_std_i(i) = PE_std;
end 

i = 1:1:9;
i = (i-1)*10;
%subplot(2,1,1);
figure(1);
errorbar(i,V_avg_i,V_std_i);
title('Molar V at 300K vs Ca Composition');
xlabel('x(Ca %)');
ylabel('V (A^(3)/mol)' );
xlim([0 80]);
%subplot(2,1,2);
figure(2);
errorbar(i,PE_avg_i, PE_std_i);
title('Molar PE at 300K vs Ca Composition');
xlabel('x(Ca %)');
ylabel('PE (KJ/mol)' );
xlim([0 80]);
