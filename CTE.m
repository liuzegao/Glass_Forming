clear,clc;close all;

user = input('User is ','s');

%%Constants
NA = 6.02214*10^(23);

CTE_i = zeros(1,9);
for i = 1:1:9
    for j = 2:2
        if j == 1
            column =3;
        else
            column =5;
        end
        cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i-1)*10),'S',num2str((11-i)*10)])
        data = dlmread('thermo_cooling.dat');
        data(:,5)= data(:,5)/(3000) * NA * (3-i/10) * (10^-8)^3;
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
        Approx_low = 800;    % T below Transition T
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
    P = polyfit(T(Ih:end), data(Ih:end,column), 1);
    if j==1
        fprintf('Ca Composition %0.2f%% PE Tg is %8.1f K\n',(i-1)*10,T_inter); 
        fprintf('CTE = %0.6f\n',P(1)/data(3700,5));
    else
        fprintf('Ca Composition %0.2f%% Volume Tg is %8.1f K\n',(i-1)*10,T_inter); 
        fprintf('CTE = %0.6f\n',P(1)/data(3700,5));
    end
    CTE_i(i) = P(1)/data(3700,5);
    %fprintf('pl2 is %0.6f K\n',pl(1));
    %fprintf('ph2 is %0.6f K\n',ph(1));

    %subplot(1,2,j);
    
    
    %plot(T(1:Ih), x(1:Ih,n),'o', 2500:5000,polyval(ph,2500:5000), T(Il:end), x(Il:end,n),'o', 300:3000, polyval(pl,300:3000),T,x(:,n),'.');
    %plot(1000:4000,polyval(ph,1000:4000), 1000:3000, polyval(pl,1000:3000));
  
    result=sortrows([T, data(:,column)],1);

    [y,I_h]=min(abs(result(:,1)-4000));
    [y,I_l]=min(abs(result(:,1)-300));

    y_smoothed=result(:,2);%smooth(result(:,2),100);
    %plot(result(I_l:I_h,1),y_smoothed(I_l:I_h),'.','Color','c');
    if j == 1
        %title(['Ca Composition',num2str((i-1)*0.1),' PE']);
    else
        %title(['Ca Composition',num2str((i-1)*0.1),' Volumn']);
    end
   

    end
end
i = 1:1:9;
i = (i-1)*10;
plot(i,CTE_i);
title('CTE vs Ca Composition');
xlabel('x(Ca %)');
ylabel('CTE (T\^-1)' );