clear all; close all; clc;


user = input('User is ','s');
%defualt Ca composition = 30%

%i_c is now from 1:9 meaning 0% to 80% 
Ca_around_per_BO = zeros(1,8);
 
for  i_c = 1:9
    if (i_c == 1)
        continue 
    end
switch(i_c)
    case 2    
    Cutoff = 2.75;
    case 3    
    Cutoff = 3.15; %3.15 
    case 4    
    Cutoff = 3.05;
        case 5    
    Cutoff = 3.05;
        case 6    
    Cutoff = 3.25;
        case 7    
    Cutoff = 3.05;
        case 8    
    Cutoff = 2.95;
    case 9 
    Cutoff = 2.65;
end
    
cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)])


 fid = fopen('TestTraj.lammpstrj', 'r') ;              % Open source file.
 buffer = fread(fid, Inf) ;                    % Read rest of the file.
 fclose(fid);
 fid = fopen('TestTraj_m.lammpstrj','w')  ;   % Open destination file.
 fwrite(fid, buffer) ;                         % Save to file.
 fclose(fid) ;
 
 traj = dlmread('TestTraj_m.lammpstrj');



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

L= 34.9159548486583; %%units?
N_atom = size(traj(:,1));
NBO = 0;
BO = 0;
FO = 0;
N_BO = 0;
Ca_around = 0;
for atom_BO = 1:1:N_atom
    if traj(atom_BO,2) == 9
        N_BO = N_BO+1;
        for atom_Ca = 1:1:N_atom
            if traj(atom_Ca,2) == 5
                if abs(traj(atom_Ca,3)-traj(atom_BO,3)) < L/2
                    x_delta = abs(traj(atom_Ca,3)-traj(atom_BO,3));
                else
                    x_delta = abs(L-abs(traj(atom_Ca,3)-traj(atom_BO,3)));      
                end
                if abs(traj(atom_Ca,4)-traj(atom_BO,4)) < L/2
                    y_delta = abs(traj(atom_Ca,4)-traj(atom_BO,4));
                else
                    y_delta = abs(L-abs(traj(atom_Ca,4)-traj(atom_BO,4)));
                end
                if abs(traj(atom_Ca,5)-traj(atom_BO,5)) < L/2
                    z_delta = abs(traj(atom_Ca,5)-traj(atom_BO,5));
                else
                    z_delta = abs(L-abs(traj(atom_Ca,5)-traj(atom_BO,5)));
                end
                    distance_min = sqrt(x_delta^2+y_delta^2+z_delta^2);               
                if distance_min <= Cutoff
                    Ca_around = Ca_around+1;
                end
            end
        end    
    end
end 
if i_c == 5
    fprintf('N_NBO is %0.3f \n', N_BO')
end
fprintf('Average Ca_around/BO at C%0.0fS%0.0f is %0.3f \n', (i_c-1)*10,(11-i_c)*10,Ca_around/N_BO);

%NBOratio_i(i_c) = NBO/N_BO;
%BOratio_i(i_c) = BO/N_BO;
%FOratio_i(i_c) = FO/N_BO;
Ca_around_per_BO(i_c-1)= Ca_around/N_BO;
end

i = 2:1:9;
i = (i-1)*10;
plot(i,Ca_around_per_BO)
title('Ca around per BO atom vs Ca composition');
xlabel('x(Ca %)');
ylabel('Average Number of Ca aounrd per BO' );

%{
i = 1:1:9;
i = (i-1)*10;
NumberNBO =NBOratio_i.*N_BO;
N_Ca = 1090;
NBoratio_Model = NumberNBO./(N_Ca);
k = 1:1:9;
k = (k-1)*0.1;
NBO_theory = 2*k./(2-k);
AllOxygen = 1;
% plot(i,NBOratio_i,i,NBO_theory)
plot(i,NBOratio_i,i,BOratio_i,i,FOratio_i,i,NBoratio_Model);
a = axis;
hold on
plot(a(1:2),[1,1]);
hold off
title('NBO,BO,FO ratio vs Ca Composition');
xlabel('x(Ca %)');
ylabel('OxygenType/Numer of O' );
legend('NBO simulation','BO','FO','NBOratio Model');
%}