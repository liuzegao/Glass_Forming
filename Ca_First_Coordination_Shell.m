%% Calcium First Coordination Shell %%
hold on
plot (Comp, CaO, '-', 'LineWidth',1);
plot (Comp, BO, '-', 'LineWidth',1);
plot (Comp, NBO, '-','LineWidth',1);
plot (Comp, FO, '-','LineWidth',1);
title('\fontsize{16}Caicium First Coordination Shell','Fontsiz',12);
xlabel('Ca Composition %','Fontsiz',12,'fontweight','bold');
ylabel('1st Coordination Shell','Fontsiz',12,'fontweight','bold');
legend({'Ca-O','BO','NBO','FO'},'FontSize',12,'fontweight','bold');
