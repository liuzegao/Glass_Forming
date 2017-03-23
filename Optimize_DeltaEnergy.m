clear all;clc;close all;

%% Find Path
user = input('User is ','s');

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
cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)])
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

end
 
%% New For Loop to Test Different D_E
D_E_Initial = 0.01;
N_Try = 100;
Square_Delta_D_E=zeros(1,N_Try);
i_D_E = 0;
NBOratio_model_small = zeros(1,9);
BOratio_model_small = zeros(1,9);
FOratio_model_small = zeros(1,9);

NBOratio_model_large = zeros(1,9);
BOratio_model_large= zeros(1,9);
FOratio_model_large = zeros(1,9);

NBOratio_model_optimal = zeros(1,9);
BOratio_model_optimal= zeros(1,9);
FOratio_model_optimal = zeros(1,9);

for D_E = D_E_Initial:0.01:((N_Try)*0.01)
    %display(D_E);
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
    Square_Delta_D_E(i_D_E) = Square_Delta_D_E(i_D_E)+(NBOratio_model(i_c)-NBOratio_i(i_c))^2+(BOratio_model(i_c)-BOratio_i(i_c))^2+(FOratio_model(i_c)-FOratio_i(i_c))^2; %Calculate the square difference
    
    %%Save two selected comparing data
        if D_E == 0.3 && i_c == 9
            NBOratio_model_optimal = NBOratio_model;
            BOratio_model_optimal =   BOratio_model;
            FOratio_model_optimal = FOratio_model;
        end
        if (i_D_E == 20) && i_c == 9
            NBOratio_model_small = NBOratio_model;
            BOratio_model_small =  BOratio_model;
            FOratio_model_small = FOratio_model;
        end
        if D_E == 0.3+10*0.01  && i_c == 9
            NBOratio_model_large = NBOratio_model;
            BOratio_model_large =   BOratio_model;
            FOratio_model_large = FOratio_model;
        end
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Plot

figure(1)
D_E = D_E_Initial:0.01:((N_Try)*0.01);
plot(D_E,Square_Delta_D_E);
title('Delta Energy VS BO NBO & FO Ratio Square Difference','fontsize',16,'fontweight','bold');
xlabel('Delta E (eV)','fontsize',14);
ylabel('Square Difference (Arb.)' ,'fontsize',14);

figure(2)
i = 1:1:9;
i = (i-1)*10;
hold on
p = plot(i,NBOratio_model_optimal,'-sr',i,BOratio_model_optimal,'-sk',i,FOratio_model_optimal,'-s',i,NBOratio_model_small,'-.o',i,BOratio_model_small,'-.o',i,FOratio_model_small,'-.o',i,NBOratio_model_large,'-.o',i,BOratio_model_large,'-.o',i,FOratio_model_large,'-.o',... 
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerFaceColor',[0.5,0.5,0.5]);
p(1).Color= [1,0,0];
p(4).Color= [0.3,0,0];
p(7).Color= [1,0.6,0];

p(2).Color= [0,0,0];
p(5).Color= [0.6,0,0];
p(8).Color= [0,0.6,0];

p(3).Color= [0,0,1];
p(6).Color= [0,0,0.3];
p(9).Color= [0,0.7,1];
plot(i,NBOratio_i,'pr',i,BOratio_i,'pk',i,FOratio_i,'pb',...
       'LineWidth',2,...
       'MarkerSize',15,...
       'MarkerFaceColor',[0.5,0.5,0.5]);
axis([0 80 0 1]);
title('Two-states Model Plot','fontsize',16,'fontweight','bold');
xlabel('x(Ca %)','fontsize',14);
ylabel('OxygenType/Numer of O' ,'fontsize',14);
legend('NBO Model Optimal','BO Model Optimal','FO Model Optimal','NBO Model Small','BO Model Small','FO Model Small','NBO Model Large','BO Model Large','FO Model Large','NBO Simulation','BO Simulation','FO Simulation','fontweight','bold');

hold off;



