function [x,xcleaned, v,vdot,m, n, spray] =FullOn(x,L, v, vdot, m, mmin, Fclean, mdot, t)
%LONGON First allow to reach 10ms-1 then turn off and once v = 2 use what
%is left to clean
%%Set Range of allowable velocities

%%Work out the velocities and toggle the spraying until the device has
%%travelled the length of the LHC

n = 1;

spray(n) = 1;

xcleaned =0;

    while (m(n) > mmin)
        n = n+1;
        D = GetDrag(v(n-1),m(n-1));
        spray(n) = 1;
        
        [ x(n),xcleaned, v(n), vdot(n), m(n) ] = Clean(x(n-1), xcleaned, v(n-1), m(n-1),mdot, Fclean, t, D );

    end
end

