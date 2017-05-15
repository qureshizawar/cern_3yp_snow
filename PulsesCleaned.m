function [x, v,vdot,m, n, xcleaned, spray] =PulsesCleaned(x,L, v, vdot, m, mmin, Fclean, mdot, t, T1, T2)
xcleaned =0;
n = 1;
spray(n) = 1;
On = 1;
i=1;
while ( x(n) < L && m(n) > mmin)
        n=n+1;
        D = GetDrag(v(n-1),m(n-1));
    if On == 1
        if i*t < T1
            spray(n) =1;
            i = i +1;
        else
            i =1;
            On = 0;
            spray(n) =0;
        end
    end
    
    if On == 0
        if i*t < T2
            spray(n) =0;
            i = i +1;
        else
            i =1;
            On = 1;
            spray(n) =1;
        end
    end
        
    
    if spray(n) ==1;
          [ x(n),xcleaned, v(n), vdot(n), m(n) ] = Clean(x(n-1), xcleaned, v(n-1), m(n-1),mdot, Fclean, t, D );
    else
          [ x(n),xcleaned, v(n), vdot(n), m(n) ] = NoClean(x(n-1),xcleaned,v(n-1),m(n-1),t, D );
    end

end

xtravel = x(n);
end

