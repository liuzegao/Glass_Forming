clear,clc;close all;

for i = 9:1:9
    figure(i)
    for j = 1:1
        if j == 1
            column =3; % PE
        else
            column =5;
        end
        cd (['/Users/vickihuuu/Desktop/CS_Tg_2nd/C',num2str((i-1)*10),'S',num2str((11-i)*10)])
        data = dlmread('cool.dat');
        T=data(:,2);
        PE= data(:,3);
            %% Molar Potential Energy %%

            % V_lammps = [Kcal/mole]
            % V_lammps / NA = [Kcal]
            % [Kcal] * 4.184 = U_ev [KJ];
        NA= 6.022*10^23;
        PE_m = PE/ NA * 4.184 / (300) * NA * (3-0.8);
        
        %         switch(i)
        %         case {1,2,3,4,5}
        %         Approx_low = 1000;    % T below Transition T
        %         Approx_Hlow = 2000;   % T above Transition T
        %         Approx_Hhigh = 3500;  % T below Mix
        %         case 6
        %         Approx_low = 800;     % T below Transition T
        %         Approx_Hlow = 2000;   % T above Transition T
        %         Approx_Hhigh = 3500;  % T below Mix
        %         case 7
        %         Approx_low = 800;    % T below Transition T
        %         Approx_Hlow = 2000;   % T above Transition T
        %         Approx_Hhigh = 3500;  % T below Mix
        %         case {8,9}
        %         Approx_low = 1000;    % T below Transition T
        %         Approx_Hlow = 1800;   % T above Transition T
        %         Approx_Hhigh = 3000;  % T below Mix
        %         end
        %
        %     [y,Ih]=min(abs(T-Approx_low));
        %     [pl,sl]=polyfit(T(Ih:end), data(Ih:end,column), 1);
        %     [y,iH]=min(abs(T-Approx_Hhigh));
        %     [y,Il]=min(abs(T-Approx_Hlow));
        %     [ph,sh]=polyfit(T(iH:Il), data(iH:Il,column), 1);
        %
        %     T_inter=(pl(2)-ph(2))/(ph(1)-pl(1));
        %     if j==1
        %         fprintf('Ca Composition %0.2f%% PE Tg is %8.1f K\n',(i-1)*10,T_inter);
        %     else
        %         fprintf('Ca Composition %0.2f%% Volume Tg is %8.1f K\n',(i-1)*10,T_inter);
        %     end
        %     %fprintf('pl2 is %8.1f K\n',pl(1));
        %     %fprintf('ph2 is %8.1f K\n',ph(1));
        %
        %     %subplot(1,9,i);
        %     hold on;
        %
        %     %plot(T(1:Ih), x(1:Ih,n),'o', 2500:5000,polyval(ph,2500:5000), T(Il:end), x(Il:end,n),'o', 300:3000, polyval(pl,300:3000),T,x(:,n),'.');
        %     plot(1000:4000,polyval(ph,1000:4000), 1000:3000, polyval(pl,1000:3000));
        %     result=sortrows([T, data(:,column)],1);
        %
        %     [y,I_h]=min(abs(result(:,1)-4000));
        %     [y,I_l]=min(abs(result(:,1)-300));
        %
        %     y_smoothed=result(:,2);%smooth(result(:,2),100);
        %
        %     plot(result(I_l:I_h,1),y_smoothed(I_l:I_h),'.','Color','c');
        %     if j == 1
        %         title(['Ca Composition',num2str((i-1)*0.1),' PE']);
        %     else
        %         title(['Ca Composition',num2str((i-1)*0.1),' Volumn']);
        %     end
        %
        % hold off;
    end
end
plot (T,PE_m,'linewidth',1);
hold on

clear all;
for i = 9:1:9
    figure(i)
    for j = 1:1
        if j == 1
            column =3; % PE
        else
            column =5;
        end
        cd (['/Users/vickihuuu/Desktop/CS_Tg_2nd/C',num2str((i-1)*10),'S',num2str((11-i)*10)])
        data = dlmread('heat.dat');
        T=data(:,2);
        PE= data(:,3);
        NA= 6.022*10^23;
        PE_m = PE/ NA * 4.184 / (300) * NA * (3-0.8);
    end
end
plot (T,PE_m,'linewidth',1);
hold off
title('Tg-Cooling and Heating of Ca Composition 80%','fontsize',16);
xlabel('T(K)','fontsize',14);
ylabel('Molar PE','fontsize',14);
legend('Cooling','Heating');

