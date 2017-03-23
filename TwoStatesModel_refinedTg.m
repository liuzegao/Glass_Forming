clear all;clc;close all;

%% Prepare Variable
k = 8.617*10^-5;
NBOratio_simulation = zeros(1,9); 
NBO_simulation = zeros(1,9); 
BOratio_simulation= zeros(1,9);
BO_simulation= zeros(1,9);
FOratio_simulation = zeros(1,9);
FO_simulation = zeros(1,9);
NBOratio_model = zeros(1,9);
BOratio_model = zeros(1,9);
FOratio_model = zeros(1,9);

Si_simulation = zeros(1,9); 
O_simulation = zeros(1,9);
Ca_simulation = zeros(1,9);
for  i_c = 1:9 %i_c from 1:9 referst to Ca composition from 0% to 80%
    cutoff_Si_O = 2.05;
    D_E = 0.5; %%Test Delta Energy between State 1 and State 2 
    switch(i_c) %Select Different Tg
    case 1
         Tg = 1800.6;
        D_E = 1.2;
    case 2
        D_E = 1.2;
         Tg =1675.0;
    case 3
       D_E = 1.2;
       Tg= 1791.6;
    case 4
        D_E = 1;
         Tg =1469.9;
    case 5
       D_E = 1.2;
       Tg = 1347.7 ;
    case 6 
        D_E = 0.5;
        Tg = 1202.5;
    case 7
        D_E = 0.5;
        Tg = 1160.9 ;
        cutoff_Si_O = 1.95;
    case 8
        D_E = 0.3; %%Test D_E Can I do this?
        Tg = 1132.4 ;
        cutoff_Si_O = 2.05;
    case 9
        D_E = 1.1;
        Tg = 1166.7 ;
        cutoff_Si_O = 2.05;
    end
    display(i_c)
    %% Input Data 
    if ispc   
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS 2500K/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)])
    else
    %/Users/zegaoliu/Dropbox/CS Glasses/C80S20
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)]) 
    end
    data = fopen('md300K.lammpstrj');
    %%Pre-processing Data and convert to a matrix in traj
    if i_c == 3 || i_c == 5 %In old data, only composition 20 and 40 has 101 frames
        N_frame = 101;
    else
        N_frame = 21;
    end
    NBO = 0;
    BO = 0;
    FO = 0;
    N_O = 0;
    N_Ca = 0;
    N_Si = 0;
    for i_frame = 1:1:N_frame   %for frame
        for n=1:4
            tline = fgetl(data); 
        end
        N_atom = str2num(tline);
        tline = fgetl(data);
        tline = fgetl(data);
        L_item(1,:) = str2num(tline);
        L = L_item(1,2);
        for n=7:9
            tline = fgetl(data);
        end
        traj = zeros(N_atom,5);
        for i =1:1:N_atom  %First time step 4410000 Last time step 4510000  
            tline = str2num(fgetl(data));
            traj(i,:)=tline; %traj=matrix
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
                        if distance_min <= cutoff_Si_O
                            Si_around = Si_around+1;
                        end
                    end
                end
                if Si_around == 0  %% Question: Is only 1 Si atom around considered NBO ?
                        FO = FO+1;
                elseif Si_around == 1
                        NBO = NBO+1;
                elseif Si_around == 2
                        BO = BO+1;       
                end      
            end
        end
    end %End Frame
    display(L);
    %Simulation Data Calculation
    NBOratio_simulation(i_c) = NBO/N_O;
    NBO_simulation(i_c) = NBO;
    BOratio_simulation(i_c) = BO/N_O;
    BO_simulation(i_c) = BO;
    FOratio_simulation(i_c) = FO/N_O;
    FO_simulation(i_c) = FO; 
    
    Si_simulation(i_c) = N_Si;    
    Ca_simulation(i_c) = N_Ca;
    O_simulation(i_c) = N_O;    
    %% Calculate Theoretical Value and Build Two-States Model
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
    
    %Theoretical Data Calculation
    NBOratio_model(i_c) = N_NBO/N_O;
    BOratio_model(i_c) = N_BO/N_O;
    FOratio_model(i_c) = N_FO/N_O;

    d_NBO_i(i_c) = N_NBO/N_O - NBO/N_O;
    d_BO_i(i_c) = N_BO/N_O - BO/N_O;
    d_FO_i(i_c) = N_FO/N_O - FO/N_O;
end
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Plot
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





