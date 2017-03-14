clear all; close all; clc;

user = input('User is ','s');
%defualt Ca composition = 30%
%i_c is now from 1:9 meaning 0% to 80% 

NBO_around_per_Ca = zeros(1,8);  
BO_around_per_Ca = zeros(1,8); 
FO_around_per_Ca = zeros(1,8);
TO_around_per_Ca = zeros(1,8); 
figure(1);
for  i_c = 1:9
    
    if i_c == 1
        continue;
    end
cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)])

data = fopen('md300K_refined.lammpstrj');
for i_frame = 1:1:21  %for frame

for n=1:4
  tline = fgetl(data);
end
N_atom = str2num(tline);
for n=5:9
  tline = fgetl(data);
end
traj = zeros(N_atom,5);
for i =1:1:N_atom  %%First time step 4410000 Last time step 4510000  
    tline = str2num(fgetl(data));
    traj(i,:)=tline;
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

L= 34.9159548486583; %%units?
N_atom = 2995;
NBO_a_Ca = 0;
BO_a_Ca = 0;
FO_a_Ca = 0;
TO_a_Ca = 0;
N_O = 0; 
N_Ca = 0;
O_around_Ca = [];
        for atom_Ca = 1:1:N_atom
            if traj(atom_Ca,2) == 5   %% Find the Ca atom    
            N_Ca = N_Ca+1;
            O_around = 0;
            O_index = [];
            for atom_O = 1:1:N_atom
                if traj(atom_O,2) == 4
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
                    if distance_min <= 3.05  %Ca first CN shell is 3.05A
                        O_index = [O_index atom_O];
                        O_around = O_around +1;
                    end
                end
            end
            O_around_Ca = [O_around_Ca O_around];
             for  i_O = 1:1:size(O_index,2); % 2 is the number of row of O_index
             Si_around = 0;
            for atom_Si = 1:1:N_atom
             if traj(atom_Si,2) == 2
                if abs(traj(atom_Si,3)-traj(O_index(i_O),3)) < L/2
                    x_delta = abs(traj(atom_Si,3)-traj(O_index(i_O),3));
                else
                    x_delta = abs(L-abs(traj(atom_Si,3)-traj(O_index(i_O),3)));      
                end
                if abs(traj(atom_Si,4)-traj(O_index(i_O),4)) < L/2
                    y_delta = abs(traj(atom_Si,4)-traj(O_index(i_O),4));
                else
                    y_delta = abs(L-abs(traj(atom_Si,4)-traj(O_index(i_O),4)));
                end
                if abs(traj(atom_Si,5)-traj(O_index(i_O),5)) < L/2
                    z_delta = abs(traj(atom_Si,5)-traj(O_index(i_O),5));
                else
                    z_delta = abs(L-abs(traj(atom_Si,5)-traj(O_index(i_O),5)));
                end
                    distance_min = sqrt(x_delta^2+y_delta^2+z_delta^2);
                if distance_min <= 1.8
                    Si_around = Si_around+1;
                end
             end
            end
                if Si_around == 0  %% Question: Is only 1 Si atom around considered NBO ?
                    FO_a_Ca = FO_a_Ca+1;
                elseif Si_around == 1
                    NBO_a_Ca = NBO_a_Ca+1;
                elseif Si_around == 2
                    BO_a_Ca = BO_a_Ca+1; 
                elseif Si_around == 3
                    TO_a_Ca = TO_a_Ca+1;
                end      
                
             end %%
            end
        end 
Tot_O_a_Ca = sum(O_around_Ca);
%fprintf('NBO/O ratio f at C%0.0fS%0.0f is %0.3f \n', (i_c-1)*10,(11-i_c)*10,NBO/N_O);
%subplot(3,3,i_c);
%{
if i_c ~= 1
    histfit(O_around_Ca,20);
end
title(['O Number vs ',num2str((i_c-1)*10), '% Ca Composition']);
xlabel('Number of O');
ylabel('Frequency' );
%}
end %for frame
NBO_around_per_Ca(i_c-1) = NBO_a_Ca/N_Ca;
BO_around_per_Ca(i_c-1) = BO_a_Ca/N_Ca;
FO_around_per_Ca(i_c-1) = FO_a_Ca/N_Ca;
end

i = 2:1:9;
i = (i-1)*10;
AO = NBO_around_per_Ca+BO_around_per_Ca+FO_around_per_Ca;
figure(2)
plot(i,NBO_around_per_Ca./AO,i,BO_around_per_Ca./AO,i,FO_around_per_Ca./AO,i,AO)
 title('O around Ca portion s Ca Composition');

xlabel('x(Ca %)');
ylabel('Average Number Around Each Ca' );
legend('NBO','BO','FO','All O');