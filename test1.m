clear all; close all; clc;

BO = [0.9845    0.8934    0.5304    0.6465    0.1459    0.2983    0.1459    0.0420    0.0073];
NBO = [0.0130    0.1056    0.4030    0.3508    0.7626    0.6433    0.7626    0.7742    0.6038];
FO = [0.0010    0.0005    0.0660    0.0027    0.0915    0.0584    0.0915    0.1838    0.3889];
AO = BO+NBO+FO;


i = 1:1:9;
i = (i-1)*10;
k = 1:1:9;
k = (k-1)*0.1;
NBO_theory = 2*k./(2-k);
plot(i,BO,i,NBO,i,FO,i,NBO_theory,i,AO)
 title('O ratio s Ca Composition');
xlabel('x(Ca %)');
ylabel('NBO/NO' );
legend('BO','NBO-Simulation','FO','NBO-Theoretical','All O');
