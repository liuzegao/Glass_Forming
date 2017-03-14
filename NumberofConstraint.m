clear all; close all; clc;


user = input('User is ','s');

n_c = zeros(1,9);
N_Si_ic = zeros(1,9);
N_Ca_ic = zeros(1,9);
N_BO_ic = zeros(1,9);
N_NBO_ic = zeros(1,9);
N_FO_ic = zeros(1,9);
N_TotalO_ic = zeros(1,9);

for  i_c = 1:9
switch(i_c)
    %N_FO_around_Ca+N_NBO_around_Ca
    case 2
        N_NBO_around_Ca =  3.366300366300366;
        N_FO_around_Ca =  0.0398351648351648;
    case 3
        N_NBO_around_Ca =  3.997774810858923;
        N_FO_around_Ca =  0.018469069870939;
    case 4
        N_NBO_around_Ca =  4.357855717137154;
        N_FO_around_Ca =  0.061305959509552;
    case 5
        N_NBO_around_Ca =  4.566584209441352;
        N_FO_around_Ca = 0.332508761080190;
    case 6
        N_NBO_around_Ca =  4.649761904761904;
        N_FO_around_Ca = 0.456587301587302;
    case 7
        N_NBO_around_Ca =  4.710730158730159;
        N_FO_around_Ca = 0.672317460317460;
    case 8
        N_NBO_around_Ca =  4.165780973220798;
        N_FO_around_Ca = 1.465666354068980;
    case 9
        N_NBO_around_Ca =  2.911620795107034;
        N_FO_around_Ca = 2.864307557885540;
end
cd (['/Users/',user,'/Dropbox/CS Glasses/C',num2str((i_c-1)*10),'S',num2str((11-i_c)*10)])
data = fopen('md300K_refined.lammpstrj');

N_Si = 0;
N_Ca = 0;
N_BO = 0;
N_NBO = 0;
N_FO = 0;

for i_frame = 1:1:21  %for frame
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
    for index_atom = 1:1:N_atom
        if traj(index_atom,2) == 2
           N_Si = N_Si+1;
        elseif traj(index_atom,2) == 5
           N_Ca = N_Ca+1;
        elseif traj(index_atom,2) == 9
            N_BO = N_BO+1;
        elseif traj(index_atom,2) == 10
            N_NBO = N_NBO+1;
        elseif traj(index_atom,2) == 11
            N_FO = N_FO + 1;
        end        
    end
    display(i_frame);
end %%End for frame

Total_Atom = N_Si+N_Ca+N_BO+N_NBO+N_FO;
N_TotalO_ic(1,i_c) = N_BO+N_NBO+N_FO ;
N_Si_ic(1,i_c) = N_Si;
N_Ca_ic(1,i_c) = N_Ca;
N_BO_ic(1,i_c) = N_BO;
N_NBO_ic(1,i_c) = N_NBO;
N_FO_ic(1,i_c) = N_FO;
if i_c ~= 1
n_c(1,i_c) = N_Si/Total_Atom*9+N_BO/Total_Atom+(N_FO_around_Ca+N_NBO_around_Ca)*N_Ca/Total_Atom;
end
display(i_c);
end
n_c(1,1) = 3;

figure(1)
i = 1:1:9;
i = (i-1)*10;
y1 = zeros(9);
y2 = zeros(9);
for k =1:1:9
    y1(k) = 3-0.05;
    y2(k) = 3+0.05;
end
plot(i,n_c,'-bs',i,y1,'--r',i,y2,'--g')
title('\fontsize{16}Number of Constraints per Atom vs Ca Composition','Fontsiz',12);
xlabel('x(Ca %)','Fontsiz',12,'fontweight','bold');
ylabel('nc','Fontsiz',12,'fontweight','bold' );
axis([0 80 2.8 3.7]);io

figure(2)
plot(i,N_BO_ic./N_TotalO_ic,i,N_NBO_ic./N_TotalO_ic,i,N_FO_ic./N_TotalO_ic,'LineWidth',1);
legend({'BO','NBO','FO'},'FontSize',12,'fontweight','bold');
xlabel('x(Ca %)','Fontsiz',12,'fontweight','bold');
ylabel('Ratio','Fontsiz',12,'fontweight','bold');
title('\fontsize{16}Oxygen Species Ratio vs Ca Composition','Fontsiz',12);


