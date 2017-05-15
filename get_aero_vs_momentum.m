function [drag, momentum, vanderwaals, total] = get_aero_vs_momentum(Velocity, SnowSize, Seperation, Material,Ls)

rho = 1.977;
Mu = 14.6 * 10^-6;

% Vs = 120;
Vs = Velocity;
r1 = SnowSize;
Dn = Seperation;
An = Material;


i = 100;
Ls = Ls;
% Ls = linspace( 1*10^-6,100*10^-6,i);
% i = 20;

y1 = [3 2 1.5 1.3 1.2]
x1 = [10 30 60 90 100]

p1 = polyfit(x1,y1,4)

y = [1.2 0.8 0.6 0.5 0.45]
x =  [100 500 1000 1500 2000]

p = polyfit(x,y,4)
for s = 1:i

    L = Ls(1,s);
    
    A = pi*(L/2)^2;


    Re = (Vs*rho*L)/Mu;
    
    if Re > 2000
        Cd = 0.45;
    elseif Re < 100
        Cd = polyval(p1,Re);
    else
%         Cd = Re*(-21/39800) + 1.5
          Cd = polyval(p,Re);
    end
    D(1,s) = Cd * .5 * rho * Vs^2 * A;


    d1 = 1600;
    d2 = 8940;
%     r1 = 10*10^-6;
    r2 = L/2;
    vol1 = (4/3)*pi*(r1)^3;
    vol2 = (4/3)*pi*(r2)^3;
    m1 = vol1*d1;
    m2 = vol2*d2;
    u1 = Vs;
    t = 0.0001;
    theta = 0*(pi/180);
    e = 0.5;
    cos(theta)

    v2 = ((e+1)*u1*cos(theta))/(1+(m2/m1));
    phi = atan((u1*sin(theta))/(v2 - e*u1*cos(theta)));
    phid = phi*(180/pi);
    v1 = (u1*sin(theta))/(sin(phi));

    impulse = m2*v2;
    F(1,s) = impulse/t;
    
    
    
%     An = 10^-19
%     An = 40.0000e-20
%     Dn = 0.4*10^-9

    vdw(1,s) = (An*r2)/(6*(Dn)^2);
end

T = D + F;

drag = D;
momentum = F;
vanderwaals = vdw;
total = T;

% plot(Ls,D,'b--',Ls,F,'g--',Ls,T,'m',Ls,vdw,'r','LineWidth',2')
% 
% grid on
% title('Aerodynamic drag vs Momentum transfer')
% xlabel('Particle diameter(m)')
% ylabel('Force (N)')
% legend('Aero drag (120 m/s)','Momentum (20um, 120m/s)','Total removal force','Van der Waals (Cu & Au)')