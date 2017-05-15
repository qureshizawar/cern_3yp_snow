i = 100;
j = 100;
Ls = linspace( 1*10^-6,100*10^-6,i);
Dns = linspace( 0.1e-9,0.6e-9,j);

for s = 1:i

    L = Ls(1,s)

    r2 = L/2
%     An = (10)^(-19)
    An_Cu = 40.0000e-20
    An_Au = 40.0000e-20
    An_Al = 36.0000e-20
    An_Al2O3 = 16.7500e-20
    An_Ag = 50.0000e-20
    Dn = 0.4e-9

    vdw_Cu(1,s) = (An_Cu*r2)/(6*(Dn)^2)
    vdw_Al(1,s) = (An_Al*r2)/(6*(Dn)^2)
    vdw_AL2O3(1,s) = (An_Al2O3*r2)/(6*(Dn)^2)
%     vdw_Ag(1,s) = (An_Ag*r2)/(6*(Dn)^2)

    for t = 1:j
        D = Dns(1,t);
        vdw_Cud(t,s) = (An_Cu*r2)/(6*(D)^2);
    end
end

figure
plot(Ls,vdw_Cu,'y',Ls,vdw_Al,'c',Ls,vdw_AL2O3,'k','LineWidth',2')
grid on
title('Van der Waals')
xlabel('Particle diameter(m)')
ylabel('Force (N)')
legend('Cu & Au','Al','Al_2O_3')

figure
surf(Ls,Dns,vdw_Cud)
grid on
title('Van der Waals')
xlabel('Particle diameter(m)')
ylabel('Surface-Contaminant Spacing (m)')
zlabel('Force (N)')
% legend('Cu & Au')