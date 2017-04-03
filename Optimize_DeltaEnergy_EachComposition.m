clear all;clc;close all;

cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/Glass_Forming_Matlab_DB'])

load('TwoStatsModel_Revised.mat') 


%% New For Loop to Test Different D_E
D_E_Initial = 0.01;
N_Try = input('Input the number of try £¨step size is 0.01eV, defualt number of try is 100) ');
Test_ic = input('Input the Ca composition (%£©');
Square_Delta_D_E=zeros(1,N_Try);
i_D_E = 0;


for D_E = D_E_Initial:0.01:((N_Try)*0.01)
    i_D_E = i_D_E+1;
    NBOratio_model = zeros(1,9);
    BOratio_model = zeros(1,9);
    FOratio_model = zeros(1,9);
    for i_c = 1:9
        switch(i_c) %Select Different Tg
        case 1
            Tg = 1435.0;
            %D_E = 0.5;
        case 2
            %D_E = 0.5;
            Tg =2160.9;
        case 3
           %D_E = 0.5;
           Tg= 2597.1;
        case 4
            %D_E = 1;
            Tg =1587.0;
        case 5
           %D_E = 0.5;
           Tg = 1523.8 ;
        case 6 
            %D_E = 0.5;
            Tg = 1475.0;
        case 7
            %D_E = 0.8;
            Tg = 1450.4 ;
        case 8
            %D_E = 1; %%Test D_E Can I do this?
            Tg = 1492.4 ;
        case 9
           %D_E = 0.1;
           Tg = 1501.1 ;
        end
    N_O = O_simulation(i_c);
    N_Ca = Ca_simulation(i_c);
    N_Si = Si_simulation(i_c);
    
    N_NBO=0;
    N_BO=N_O-N_Ca;
    N_FO=0; %Number of Structure 1 
    N_M1=0;
    N_M2=0;
    P_M1 = 1/(exp(-D_E/(k*Tg))+1);  %M1 -> Model 1 Ordered Model 

    for j = 1:1:N_Ca
        if N_NBO <= 4*N_Si
        if N_BO > 0 % When there is still BO existing
            if rand < P_M1  %M1
                N_NBO = N_NBO+2;
                N_BO = N_BO - 1;
            else
                if N_NBO >0
                    N_FO = N_FO +1;
                else
                    N_NBO = N_NBO+2;
                    N_BO = N_BO - 1;
                end
            end
        else % When there is no BO left
            if rand < P_M1  %M1
                N_FO = N_FO +1;
            else
                N_FO = N_FO+1;
            end
        end
        else
            N_FO=N_FO+1;
        end
    end
    NBOratio_model(i_c) = N_NBO/N_O;
    BOratio_model(i_c) = N_BO/N_O;
    FOratio_model(i_c) = N_FO/N_O;
    if i_c == (Test_ic/10+1)
        Square_Delta_D_E(i_D_E) = Square_Delta_D_E(i_D_E)+(NBOratio_model(i_c)-NBOratio_simulation(i_c))^2+(BOratio_model(i_c)-BOratio_simulation(i_c))^2+(FOratio_model(i_c)-FOratio_simulation(i_c))^2;
    end
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Plot

D_E = D_E_Initial:0.01:((N_Try)*0.01);
plot(D_E,Square_Delta_D_E);
title('Delta Energy VS BO NBO & FO Ratio Square Difference','fontsize',16,'fontweight','bold');
xlabel('Delta E (eV)','fontsize',14);
ylabel('Square Difference (Arb.)' ,'fontsize',14);
%{
i = 1:1:9;
i = (i-1)*10;
plot(i,NBOratio_model,'-.or',i,BOratio_model,'-.ok',i,FOratio_model,'-.ob',i,NBOratio_simulation,'-*r',i,BOratio_simulation,'-*k',i,FOratio_simulation,'-*b',... 
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerFaceColor',[0.5,0.5,0.5]);
axis([0 80 0 1]);
title('Two-states Model Plot','fontsize',16,'fontweight','bold');
xlabel('x(Ca %)','fontsize',14);
ylabel('OxygenType/Numer of O' ,'fontsize',14);
legend('NBO Model','BO Model','FO Model','NBO simulation','BO simulation','FO simulation','fontweight','bold');
%}





