clear all;clc;close all;

x = 1:1:7;
y = [1,1,0.5,1,0.5,0.25,0.12];
plot(x,y,'-o','LineWidth',2,...
    'MarkerSize',5,...
    'MarkerFaceColor',[0.5,0.5,0.5]);
title('Optimal Delta Energy VS Ca Composition','fontsize',16,'fontweight','bold');
xlabel('x(Ca %)','fontsize',14);
ylabel('Delta Energy (eV)' ,'fontsize',14);
