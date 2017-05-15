function [x,v,Vair,time, Refv, CleanDist, sprayed, NeedleValve, timestart, timestop] = Model(xclean, StartRef, LeaveRef, num, Kp, Kd )

%%Initial Conditions
x(1) = 0; L = 2800; v(1)=0; vdot(1) = 0; m(1) = 2; mmin = 1.6;

%%Cleaning Force
c = 400*sind(30); mdot = 8.3*10^(-3); Fclean = c*mdot;

%time gap and stepper
t = 0.1; n=1;

MaxAir =8;

Vair(n) = 0;

    while x(n) < xclean
        Refv(n) = StartRef;
        [ x,v,vdot,m, Vair, n ] = Wind( x, v, vdot, m,n, t, Vair, Refv(n), Kp, Kd);

    end
   
        while v(n) > 0.6   
        Refv(n) = 0;   
        [ x,v,vdot,m, Vair, n ] = Wind( x, v, vdot, m,n, t, Vair, Refv(n), Kp, Kd);  
        end

        ni = n;
        timestart = ni * t;
        
      

    [xcleaned, vcleaned,i,m,vdot, CleanDist, spray] =Cleaning(num, x(n),L, v(n), vdot(n), m(n), mmin, Fclean, mdot);
        
    Vair(n+1:n+i) = zeros(1,length(m));
    Refv(n+1:n+i) = zeros(1, length(m));
    
    
    x(n+1:n+i) = xcleaned;
    v(n+1:n+i) = vcleaned;
    m(n+1:n+i) = m;
    vdot(n+1:n+i) = vdot;
 
    n = n+i;
    
    timestop = n*t;
    
    while x(n) < L - 100
        Refv(n) = LeaveRef;
        [ x,v,vdot,m, Vair, n ] = Wind( x, v, vdot, m,n, t, Vair, Refv(n), Kp, Kd);
    end

while x(n) < L
    if Refv(n-1) > 2
        Refv(n) = Refv(n-1)*0.99;
    else
        Refv(n) = Refv(n-1);
    end
    
   
    [ x,v,vdot,m, Vair, n ] = Wind( x, v, vdot, m,n, t, Vair, Refv(n), Kp, Kd);
end

  sprayed(1:n) = zeros(1,length(1:n));
  sprayed(ni+1:ni+i) = spray;

Refv(n) = 0;

% plot(x,v,'r')
% xlabel('Distance along beam pipe (m)')
% ylabel('Velocity of device (m/s)')
% axis([0 2800 0 8])
% hold on
% plot(x,Refv,'--b')
% 
time = 1:n;
time = time * t;
% 
% figure
% plot(time, Vair)
% xlabel('Time (s)')
% ylabel('Velocity of Air (m/s)')

NeedleValve = 20 * (Vair/MaxAir);

end