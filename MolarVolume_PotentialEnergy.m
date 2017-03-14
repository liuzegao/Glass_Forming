%% Molar Volume %%

% V_lammps = [Angstrom ^ 3]
% V_m = [cm^3 /mol] around 20~30
% (Cao)x(SiO2)1-x
% # of atoms per molecule = 2x+3*(1-x)= 3-x

% Vm = V_lammps /(# of atoms in simulation) * NA * (3-x) * (10^-8)^3

%% Molar Potential Energy %%

% V_lammps = [Kcal/mole]
% V_lammps / NA = [Kcal]
% [Kcal] * 4.184 = U_ev [KJ]
% U_m = U_lammps/ NA * 4.184 / (# of atoms in simulation) * NA * (3-x)

