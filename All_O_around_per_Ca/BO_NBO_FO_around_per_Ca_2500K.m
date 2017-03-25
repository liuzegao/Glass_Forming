%%%This scripts is used to find the average number of BO NBO and Fo around
%%%Ca
clear all; close all; clc;


%defualt Ca composition = 30%
%i_c is now from 1:9 meaning 0% to 80% 

NBO_around_per_Ca = zeros(1,8); 
%NBO_around_per_Ca_Mean = zeros(1,8);
%NBO_around_per_Ca_STD = zeros(1,8);
BO_around_per_Ca = zeros(1,8); 
%NBO_around_per_Ca_Mean = zeros(1,8);
%NBO_around_per_Ca_STD = zeros(1,8);
FO_around_per_Ca = zeros(1,8);
%NBO_around_per_Ca_Mean = zeros(1,8);
%NBO_around_per_Ca_STD = zeros(1,8);
TO_around_per_Ca = zeros(1,8); 

for  i_c = 2:9 % i_c 1-> 0% 2->10% 3->10%...
switch(i_c)
    case 2    
    Cutoff_NBO_Ca = 2.85;
    Cutoff_BO_Ca = 3.05;
    Cutoff_FO_Ca = 2.55;
    case 3    
    Cutoff_NBO_Ca = 3.15;
    Cutoff_BO_Ca = 2.95;
    Cutoff_FO_Ca = 2.75;
    case 4    
    Cutoff_NBO_Ca = 2.85;
    Cutoff_BO_Ca = 3.05;
    Cutoff_FO_Ca = 2.75;
        case 5    
    Cutoff_NBO_Ca = 2.95;
    Cutoff_BO_Ca = 2.95;
     Cutoff_FO_Ca = 2.95;
        case 6    
    Cutoff_NBO_Ca = 2.95;
    Cutoff_BO_Ca = 2.95;
    Cutoff_FO_Ca = 2.95;
    case  7
    Cutoff_NBO_Ca = 2.95;
    Cutoff_BO_Ca =2.95;
    Cutoff_FO_Ca = 2.95;
         case 8    
    Cutoff_NBO_Ca = 2.95;
    Cutoff_BO_Ca = 2.95;
    Cutoff_FO_Ca = 3.05;
        case 9    
    Cutoff_NBO_Ca = 3.05;
    Cutoff_BO_Ca = 2.85;
    Cutoff_FO_Ca = 3.05;
end
 if i_c == 1 %No Ca in composition 0%
      continue;
 end
NBO_a_Ca = 0; %Number of NBO around Ca
BO_a_Ca = 0;
FO_a_Ca = 0;
TO_a_Ca = 0;
N_Ca = 0;

    if ispc   
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS 2500K/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)])
    else
    %/Users/zegaoliu/Dropbox/CS Glasses/C80S20
    cd ([getenv('HOME'),'/Dropbox/CS 2500K/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)]) 
    end

data = fopen('md2500K_refined.lammpstrj');

%%Pre-processing Data and convert to a matrix in traj
    N_frame = 21;

for i_frame = 1:1:N_frame %for frame

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

%% Parameters in the data:id type x y z 
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

        for atom_Ca = 1:1:N_atom
            if traj(atom_Ca,2) == 5  %Find the Ca atom    
                N_Ca = N_Ca+1;
            for atom_O = 1:1:N_atom
                if traj(atom_O,2) == 9 || 10 || 11
                    if abs(traj(atom_O,3)-traj(atom_Ca,3)) < L/2
                    x_delta = abs(traj(atom_O,3)-traj(atom_Ca,3));
                    else
                    x_delta = abs(L-abs(traj(atom_O,3)-traj(atom_Ca,3)));      
                    end
                    if abs(traj(atom_O,4)-traj(atom_Ca,4)) < L/2
                    y_delta = abs(traj(atom_O,4)-traj(atom_Ca,4));
                    else
                    y_delta = abs(L-abs(traj(atom_O,4)-traj(atom_Ca,4)));
                    end
                    if abs(traj(atom_O,5)-traj(atom_Ca,5)) < L/2
                    z_delta = abs(traj(atom_O,5)-traj(atom_Ca,5));
                    else
                    z_delta = abs(L-abs(traj(atom_O,5)-traj(atom_Ca,5)));
                    end
                    distance_min = sqrt(x_delta^2+y_delta^2+z_delta^2);                
                    if traj(atom_O,2) == 9 && distance_min <= Cutoff_BO_Ca  %Ca first CN shell is 3.05A
                         BO_a_Ca = BO_a_Ca+1;
                    elseif  traj(atom_O,2) == 10 && distance_min <= Cutoff_NBO_Ca 
                         NBO_a_Ca = NBO_a_Ca+1;
                    elseif traj(atom_O,2) == 11 && distance_min <= Cutoff_FO_Ca 
                         FO_a_Ca = FO_a_Ca+1;
                    end
                end
             end
            end
        end     
end %for frame
NBO_around_per_Ca(i_c-1) = NBO_a_Ca/N_Ca;
%NBO_around_per_Ca_Mean(i_c-1) = mean(NBO_around_per_Ca(i_c-1));
%NBO_around_per_Ca_STD(i_c-1) = std(NBO_around_per_Ca(i_c-1));
BO_around_per_Ca(i_c-1) = BO_a_Ca/N_Ca;
%BO_around_per_Ca_Mean(i_c-1) = mean(BO_around_per_Ca(i_c-1));
%BO_around_per_Ca_STD(i_c-1) = std(BO_around_per_Ca(i_c-1));
FO_around_per_Ca(i_c-1) = FO_a_Ca/N_Ca;
%FO_around_per_Ca_Mean(i_c-1) = mean(FO_around_per_Ca(i_c-1));
%FO_around_per_Ca_STD(i_c-1) = std(FO_around_per_Ca(i_c-1));

display(i_c); %%Show current composition 
end

i = 2:1:9;
i = (i-1)*10;
AO = NBO_around_per_Ca+BO_around_per_Ca+FO_around_per_Ca;
figure(1)
plot(i,NBO_around_per_Ca,'-*b',i,BO_around_per_Ca,'-*g',i,FO_around_per_Ca,'-*r',i,AO,'-*m',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerFaceColor',[0.5,0.5,0.5])
title('Ca Coordination Number of BO, NBO and FO vs Ca Composition');
xlabel('x(Ca %)');
ylabel('BO, NBO and FO Around Each Ca' );
legend('NBO','BO','FO','All O');

