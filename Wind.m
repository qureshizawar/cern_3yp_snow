function [ x,v,vdot,m, Vair, n ] = Wind( x, v, vdot, m,n, t, Vair, Refv, Kp, Kd )
%WIND
        Vair(n+1) = getVair(v(n),vdot(n), Refv, Vair(n), Kp, Kd, t, x(n), n );
        
        %delay = Delay(x, t);
        delay =0;
        
        Position = round((n-delay),0);
        
        if Position < 1
            Position = 1;
        end
        
        D = FindDrag(Vair(Position), v(n), m(n));
        Force = FindF(Vair(Position) - v(n));
        
        vdot(n+1) = - D/m(n) + (1/m(n))*Force;
        %Increment the velocity and position
        v(n+1) = v(n) +vdot(n) * t;
        x(n+1) = x(n) + v(n) * t + 0.5 * vdot(n) *t^2;
        
        m(n+1) = m(n);
                n = n+1; 
        
end

