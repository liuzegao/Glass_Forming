clear all; close all; clc;

user = input('User is ','s');

cd (['/Users/',user,'/Dropbox/CS Glasses/Matlab/Stakced PDF']);

hold on;
for i_c = 1:1:9
    %SiSi_Ca10
    data = dlmread(['OO_Ca',num2str((i_c-1)*10)]);
   
    
    if i_c ~= 10
     data(:,2) = data(:,2)+ (i_c-1)*1.6;
    plot(data(:,1),data(:,2),'LineWidth',2);
    end
    %legendInfo{i_c} = ['Ca Composition = ' num2str((i_c-1)*10)];
    caption = ['Ca Composition = ' num2str((i_c-1)*10),'%'];
     t=  text(data(15,1), data(15,2)+0.5, caption);
     s = t.FontSize;
     t.FontWeight = 'bold';     
        t.FontSize = 12;
end


%legend(legendInfo);
axis([1.3,6,0,16])
xlabel('r (Angstrom)','Fontsiz',12,'fontweight','bold');
ylabel('Intensity','Fontsiz',12,'fontweight','bold');
title('\fontsize{16}Pair Distribution Function for O-O','Fontsiz',12);


hold off;
