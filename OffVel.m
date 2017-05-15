function [x,xcleaned, v,vdot,m,n, spray] =OffVel(x,L, v, vdot, m, mmin, Fclean, mdot, t, vel)
n = 1;
spray(n) =1;
xcleaned =0;

    while ( x(n) < L && m(n) > mmin)
        n=n+1;
        V = v(n-1);
        D = GetDrag(v(n-1), m(n-1));
        if spray(n-1) == 1
            [ x(n),xcleaned, v(n), vdot(n), m(n) ] = Clean(x(n-1), xcleaned, v(n-1), m(n-1),mdot, Fclean, t, D );
            if v(n) > vel
                spray(n) = 0;
            else
                spray(n) = spray(n-1);
            end
        end
        if spray(n-1) ==0
            [ x(n),xcleaned, v(n), vdot(n), m(n) ] = NoClean(x(n-1),xcleaned, v(n-1), m(n-1), t, D );
            if v(n) < 0.001;
                spray(n) = 1;
            else
                spray(n) = spray(n-1);
            end
        end
    end
end

