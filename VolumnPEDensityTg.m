clear; clc;close all

user = input('User is ','s');
i = input('Ca Composition is % ')/10+1;

cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i-1)*10),'S',num2str((11-i)*10)])

%%Constants
NA = 6.02214*10^(23);
Thermodata = dlmread('thermo_cooling.dat');

%% Volume vs. Temperature Diagram
figure(1)
subplot(2,2,1)

%%Average Every 10 points
Thermodata_reshape_T=reshape(Thermodata(:,2),10,[]);
Thermodata_reshape_V=reshape(Thermodata(:,5),10,[]);
Thermodata_reshape_V = Thermodata_reshape_V/(3000) * NA * (3-0.4) * (10^-8)^3;

Thermodata_average10_T = sum(Thermodata_reshape_T,1)./size(Thermodata_reshape_T,1);
Thermodata_average10_V = sum(Thermodata_reshape_V,1)./size(Thermodata_reshape_V,1);
plot(Thermodata_average10_T,Thermodata_average10_V,'x')
%%plot(Thermodata(:,2),Thermodata(:,5));



title(['C',num2str((i-1)*10),'S',num2str((11-i)*10)])

xlabel('Temperature (K)')

ylabel('Volume (cm^-3)/mole' )

%% Potential vs. Temperature Diagram

subplot(2,2,2)

Thermodata_reshape_PE=reshape(Thermodata(:,3),10,[]);
Thermodata_reshape_PE = Thermodata_reshape_PE/ NA * 4.184 / (3000) * NA * (3-0.4);
Thermodata_average10_PE = sum(Thermodata_reshape_PE,1)./size(Thermodata_reshape_PE,1);
plot(Thermodata_average10_T,Thermodata_average10_PE,'x')

title(['C',num2str((i-1)*10),'S',num2str((11-i)*10)])

xlabel('Temperature (K)')

ylabel('PE (KJ/mole)' )


%% Density vs. Temperature Diagram

subplot(2,2,3)

Thermodata_reshape_D=reshape(Thermodata(:,6),10,[]);
Thermodata_average10_D = sum(Thermodata_reshape_D,1)./size(Thermodata_reshape_D,1);
plot(Thermodata_average10_T,Thermodata_average10_D,'x')
title(['C',num2str((i-1)*10),'S',num2str((11-i)*10)])

xlabel('Temperature (K)')

ylabel('Density (g/cm^-3)' )


%% Tg

    figure(2)
    for j = 1:2
        if j == 1
            column =3;
        else
            column =5;
        end
        cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i-1)*10),'S',num2str((11-i)*10)])
        data = dlmread('thermo_cooling.dat');
        T=data(:,2);

        switch(i)
        case {1,2,3,4,5}
        Approx_low = 1000;    % T below Transition T
        Approx_Hlow = 2000;   % T above Transition T
        Approx_Hhigh = 3500;  % T below Mix
        case 6
        Approx_low = 800;     % T below Transition T
        Approx_Hlow = 2000;   % T above Transition T
        Approx_Hhigh = 3500;  % T below Mix
        case 7
        Approx_low = 2000;    % T below Transition T
        Approx_Hlow = 2000;   % T above Transition T
        Approx_Hhigh = 3500;  % T below Mix
        case {8,9}
        Approx_low = 1000;    % T below Transition T
        Approx_Hlow = 1800;   % T above Transition T
        Approx_Hhigh = 3000;  % T below Mix
        end 
        
    [y,Ih]=min(abs(T-Approx_low));
    [pl,sl]=polyfit(T(Ih:end), data(Ih:end,column), 1);
    [y,iH]=min(abs(T-Approx_Hhigh));
    [y,Il]=min(abs(T-Approx_Hlow));
    [ph,sh]=polyfit(T(iH:Il), data(iH:Il,column), 1);

    T_inter=(pl(2)-ph(2))/(ph(1)-pl(1));
    if j==1
        fprintf('Ca Composition %0.2f%% PE Tg is %8.1f K\n',(i-1)*10,T_inter); 
    else
        fprintf('Ca Composition %0.2f%% Volume Tg is %8.1f K\n',(i-1)*10,T_inter); 
    end
    fprintf('pl2 is %8.1f K\n',pl(1));
    fprintf('ph2 is %8.1f K\n',ph(1));

    subplot(1,2,j);
    hold on;
    
%plot(T(1:Ih), x(1:Ih,n),'o', 2500:5000,polyval(ph,2500:5000), T(Il:end), x(Il:end,n),'o', 300:3000, polyval(pl,300:3000),T,x(:,n),'.');
    plot(1000:4000,polyval(ph,1000:4000), 1000:3000, polyval(pl,1000:3000));
    result=sortrows([T, data(:,column)],1);

    [y,I_h]=min(abs(result(:,1)-4000));
    [y,I_l]=min(abs(result(:,1)-300));

    y_smoothed=result(:,2);%smooth(result(:,2),100);
    plot(result(I_l:I_h,1),y_smoothed(I_l:I_h),'.','Color','c');
    if j == 1
        title(['Ca Composition',num2str((i-1)*0.1),' PE']);
    else
        title(['Ca Composition',num2str((i-1)*0.1),' Volumn']);
    end
   
hold off;
end