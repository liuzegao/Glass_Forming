clear all; close all; clc;

user = input('User is ','s');
%defualt Ca composition = 30%

%i_c is now from 1:9 meaning 0% to 80% 

NBOratio_i = zeros(1,9);    
for  i_c = 1:9
    
cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)])

data = fopen('md300K.lammpstrj');
traj = zeros(3000,5);
for n=1:9
  tline = fgetl(data);
end
for i =10:1:3004  %%First time step 4410000 Last time step 4510000  
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

L= 34.9159548486583; %%units?
N_atom = 2995;
%for Si_around_set = 1:
NBO = 0;
N_O = 0;
for atom_O = 1:1:N_atom
    if traj(atom_O,2) == 4
        Si_around = 0;
        N_O = N_O+1;
        for atom_Si = 1:1:N_atom
            if traj(atom_Si,2) == 2
                %{
                distance_1 = sqrt((traj(atom_Si,3)-traj(atom_O,3))^2+(traj(atom_Si,4)-traj(atom_O,4))^2+(traj(atom_Si,5)-traj(atom_O,5))^2);
                distance_2 = sqrt((L-(traj(atom_Si,3)-traj(atom_O,3)))^2+(L-(traj(atom_Si,4)-traj(atom_O,4)))^2+(L-(traj(atom_Si,5)-traj(atom_O,5)))^2);
                distance_3 = sqrt((L-(traj(atom_Si,3)-traj(atom_O,3)))^2+(traj(atom_Si,4)-traj(atom_O,4))^2+(traj(atom_Si,5)-traj(atom_O,5))^2);
                distance_4 = sqrt((L-(traj(atom_Si,3)-traj(atom_O,3)))^2+(L-(traj(atom_Si,4)-traj(atom_O,4)))^2+(traj(atom_Si,5)-traj(atom_O,5))^2);
                distance_5 = sqrt((traj(atom_Si,3)-traj(atom_O,3))^2+(L-(traj(atom_Si,4)-traj(atom_O,4)))^2+(traj(atom_Si,5)-traj(atom_O,5))^2);
                distance_6 = sqrt((traj(atom_Si,3)-traj(atom_O,3))^2+(L-(traj(atom_Si,4)-traj(atom_O,4)))^2+(L-(traj(atom_Si,5)-traj(atom_O,5)))^2);
                distance_7 = sqrt((traj(atom_Si,3)-traj(atom_O,3))^2+(traj(atom_Si,4)-traj(atom_O,4))^2+(L-(traj(atom_Si,5)-traj(atom_O,5)))^2);
                distance_8 = sqrt((L-(traj(atom_Si,3)-traj(atom_O,3)))^2+(traj(atom_Si,4)-traj(atom_O,4))^2+(L-(traj(atom_Si,5)-traj(atom_O,5)))^2);
                distance_min = min([distance_1,distance_2,distance_3,distance_4,distance_5,distance_6,distance_7,distance_8]);   
             %}
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
        end      
    end
end 

fprintf('NBO/O ratio f at C%0.0fS%0.0f is %0.3f \n', (i_c-1)*10,(11-i_c)*10,NBO/N_O);
NBOratio_i(i_c) = NBO/N_O;
end
i = 1:1:9;
i = (i-1)*10;

k = 1:1:9;
k = (k-1)*0.1;
NBO_theory = 2*k./(2-k);
plot(i,NBOratio_i,i,NBO_theory)
 title('NBO/NO s Ca Composition');
xlabel('x(Ca %)');
ylabel('NBO/NO' );
legend('Simulation','Theoretical')