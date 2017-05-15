function [x, v, i,m,vdot, xcleaned, spray] =VelRange(x,L, v, vdot, m, mmin, Fclean, mdot, t, vel, range)

vmin = vel - 0.5 * range;
vmax = vel + 0.5 * range;

i = 1;

%%Accelerate away at the start
spray(1) = 1;

xcleaned =0;

%%Work out the velocities and toggle the spraying until the device has
%%travelled the length of the LHC

while (m(i) > mmin)
    i = i+1;
    D = GetDrag(v(i-1),m(i-1));
    if spray(i-1) == 1
      
        %Then calculate new velocity and reassign the flag if needed 
        %vdot(n) = vdot(n-1) - D/m(n-1) + (1/m(n-1))*Fclean;
        [ x(i),xcleaned, v(i), vdot(i), m(i) ] = Clean(x(i-1), xcleaned, v(i-1), m(i-1),mdot, Fclean, t, D );

        
       
        
            if v(i) > vmax
               spray(i) =0;
            else 
               spray(i) =1;
            end
        
    else
        %Calculate new velocity and reassign the flag if needed 
       [ x(i),xcleaned, v(i), vdot(i), m(i) ] = NoClean(x(i-1),xcleaned,v(i-1), m(i-1),t, D );
        
      
            if v(i) < vmin
                spray(i) =1;
            else
                spray(i) =0;
            end

    end
end
end
