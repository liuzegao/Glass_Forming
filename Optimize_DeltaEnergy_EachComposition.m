clear all;clc;close all; 

%% Prepare Variable
k = 8.617*10^-5;
NBOratio_i = zeros(1,9); 
BOratio_i= zeros(1,9);
FOratio_i = zeros(1,9);
NBOratio_model = zeros(1,9);
BOratio_model = zeros(1,9);
FOratio_model = zeros(1,9);

N_O_i = zeros(1,9);
N_Ca_i = zeros(1,9);
N_Si_i = zeros(1,9);

for  i_c = 1:9 %i_c from 1:9 referst to Ca composition from 0% to 80%
%% Input Data 
cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)])
data = fopen('md300K.lammpstrj');
traj = zeros(3000,5);
for n=1:9
  tline = fgetl(data);
end
for i =10:1:3004  %% First time step 4410000 Last time step 4510000  
    tline = str2num(fgetl(data));
    traj(i-9,:)=tline;
end
%%id type x y z 
%{
variable        Al equal 1
variable        Si equal 2
variable        Na equal 3
variable        O equal 4
variable        Ca equal 5
variable        K equal 6
variable        Mg equal 7 
variable        Fe equal 8
%}
%% Analyze Simulation Data
L= 34.9159548486583; 
N_atom = 2995;
NBO = 0;
BO = 0;
FO = 0;
N_O = 0;
N_Ca = 0;
N_Si = 0;
for atom_O = 1:1:N_atom
    if traj(atom_O,2) == 5
        N_Ca=N_Ca+1;
    elseif traj(atom_O,2) == 2
        N_Si=N_Si+1;
    elseif traj(atom_O,2) == 4
        Si_around = 0;
        N_O = N_O+1;
        for atom_Si = 1:1:N_atom
            if traj(atom_Si,2) == 2
                if abs(traj(atom_Si,3)-traj(atom_O,3)) < L/2
                    x_delta = abs(traj(atom_Si,3)-traj(atom_O,3));
                else
                    x_delta = abs(L-abs(traj(atom_Si,3)-traj(atom_O,3)));      
                end
                if abs(traj(atom_Si,4)-traj(atom_O,4)) < L/2
                    y_delta = abs(traj(atom_Si,4)-traj(atom_O,4));
                else
                    y_delta = abs(L-abs(traj(atom_Si,4)-traj(atom_O,4)));
                end
                if abs(traj(atom_Si,5)-traj(atom_O,5)) < L/2
                    z_delta = abs(traj(atom_Si,5)-traj(atom_O,5));
                else
                    z_delta = abs(L-abs(traj(atom_Si,5)-traj(atom_O,5)));
                end
                    distance_min = sqrt(x_delta^2+y_delta^2+z_delta^2);               
                if distance_min <= 1.8
                    Si_around = Si_around+1;
                end
            end
        end
        if Si_around == 1  %% Question: Is only 1 Si atom around considered NBO ?
                NBO = NBO+1;
        elseif Si_around == 2
                BO = BO+1;
        elseif Si_around == 0
                FO = FO+1;       
        end      
    end
end 

%% Calculate Simulation Data 
NBOratio_i(i_c) = NBO/N_O;
BOratio_i(i_c) = BO/N_O;
FOratio_i(i_c) = FO/N_O;


%% Save Data 
N_O_i(i_c) = N_O;
N_Ca_i(i_c) = N_Ca;
N_Si_i(i_c) = N_Si;

%% Calculate Theoretical Value and Build Two-States Model
D_E = 0.5; %%Test Delta Energy between State 1 and State 2 
switch(i_c) %Select Different Tg
    case 1
        Tg = 1800.6;
        %D_E = 0.5;
    case 2
        %D_E = 0.5;
        Tg =1675.0;
    case 3
       %D_E = 0.5;
       Tg= 1791.6;
    case 4
        %D_E = 1;
        Tg =1469.9;
    case 5
       %D_E = 0.5;
       Tg = 1347.7 ;
    case 6 
        %D_E = 0.5;
        Tg = 1202.5;
    case 7
        %D_E = 0.8;
        Tg = 1160.9 ;
    case 8
        D_E = 0.12; %%Test D_E Can I do this?
        Tg = 1132.4 ;
    case 9
       %D_E = 0.1;
       Tg = 1166.7 ;
end
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


end
 
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
    N_O = N_O_i(i_c);
    N_Ca = N_Ca_i(i_c);
    N_Si = N_Si_i(i_c);
    
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
        Square_Delta_D_E(i_D_E) = Square_Delta_D_E(i_D_E)+(NBOratio_model(i_c)-NBOratio_i(i_c))^2+(BOratio_model(i_c)-BOratio_i(i_c))^2+(FOratio_model(i_c)-FOratio_i(i_c))^2;
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
plot(i,NBOratio_model,'-.or',i,BOratio_model,'-.ok',i,FOratio_model,'-.ob',i,NBOratio_i,'-*r',i,BOratio_i,'-*k',i,FOratio_i,'-*b',... 
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerFaceColor',[0.5,0.5,0.5]);
axis([0 80 0 1]);
title('Two-states Model Plot','fontsize',16,'fontweight','bold');
xlabel('x(Ca %)','fontsize',14);
ylabel('OxygenType/Numer of O' ,'fontsize',14);
legend('NBO Model','BO Model','FO Model','NBO simulation','BO simulation','FO simulation','fontweight','bold');
%}





