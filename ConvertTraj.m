%%%This Script is used to seperate BO NBO and Fo from O and assign them
%%%with different index 
clear all; close all; clc;


%defualt Ca composition = 30%

NBOratio_i = zeros(1,9);



if ispc
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses'])
else
    cd ([getenv('HOME'),'/Dropbox/CS Glasses'])
end
    
Cutoff= xlsread('Ca-O 1st Cutoff.xlsx');
%i_c is now from 1:9 meaning 0% to 80% 
for i_c = 1:1:9
     cutoff_Si_O =  Cutoff(32+i_c,2);
    D_E = 0.3; %%Test Delta Energy between State 1 and State 2 
    switch(i_c) %Select Different Tg
    case 1
         Tg = 1800.6;
        D_E = 1;
    case 2
        D_E = 1;
         Tg =1675.0;
    case 3
       D_E = 1;
       Tg= 1791.6;
    case 4
        D_E = 0.5;
         Tg =1469.9;
    case 5
       D_E = 1;
       Tg = 1347.7 ;
    case 6 
        D_E = 0.35;
        Tg = 1202.5;
    case 7
        D_E = 0.25;
        Tg = 1160.9 ;
    case 8
        D_E = 0.12; %%Test D_E Can I do this?
        Tg = 1132.4 ;
    case 9
        D_E = 1;
        Tg = 1166.7 ;
    end
    display(i_c)
    if ispc   
    cd ([getenv('HOMEDRIVE') getenv('HOMEPATH'),'/Dropbox/CS Glasses/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)])
    else
    %/Users/zegaoliu/Dropbox/CS Glasses/C80S20
    cd ([getenv('HOME'),'/Dropbox/CS Glasses/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)]) 
    end
data = fopen('md300K.lammpstrj');
fid = fopen('md300K_refined.lammpstrj','w');

display(i_c)
if i_c == 3 || i_c == 5 %In old data, only composition 20 and 40 has 101 frames
    N_frame = 101;
else
    N_frame = 21;
end

for i_frame = 1:1:N_frame  %for frame

        for n=1:4
        tline = fgetl(data);
            if n == 1
                Top_string(1,1) = {tline};
            else
                Top_string(1,n) = {tline};
            end
        end
        N_atom = str2num(tline);
        tline = fgetl(data);
        Top_string(1,5) = {tline};
        tline = fgetl(data);
        Top_string(1,6) = {tline};
        L_item(1,:) = str2num(tline);
        L = L_item(1,2)-L_item(1,1);
        for n=7:9
            tline = fgetl(data);
            Top_string(1,n) = {tline};
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

Custom
variable        BO equal 9
variable        NBO equal 10
variable        FO equal 11
%}

NBO = 0;
BO = 0;
FO = 0;
N_O = 0;
for atom_O = 1:1:N_atom
    if traj(atom_O,2) == 4
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
        if Si_around == 1  %% Question: Is only 1 Si atom around considered NBO ?
                NBO = NBO+1;
                traj(atom_O,2) = 10;
        elseif Si_around == 2
                BO = BO+1;
                traj(atom_O,2) = 9;
        elseif Si_around == 0
                FO = FO+1;    
                traj(atom_O,2) = 11;
        end      
    end
end 
%{
fprintf('NBO/O ratio f at C%0.0fS%0.0f is %0.3f \n', (i_c-1)*10,(11-i_c)*10,NBO/N_O);
fprintf('BO/O ratio f at C%0.0fS%0.0f is %0.3f \n', (i_c-1)*10,(11-i_c)*10,BO/N_O);
fprintf('FO/O ratio f at C%0.0fS%0.0f is %0.3f \n', (i_c-1)*10,(11-i_c)*10,FO/N_O);
NBOratio_i(i_c) = NBO/N_O;
BOratio_i(i_c) = BO/N_O;
FOratio_i(i_c) = FO/N_O;
%}
    for n=1:9
        fprintf(fid,[char(Top_string(1,n)),'\n']);
    end
    for i = 1:1:N_atom
        fprintf(fid,[num2str(traj(i,1)),' ',num2str(traj(i,2)),' ',num2str(traj(i,3)),' ',num2str(traj(i,4)),' ',num2str(traj(i,5)),'\n']);
    end
    display(i_frame);
end  %end for frame

fclose(fid);
end  %%Big For Loop for Ca composition

