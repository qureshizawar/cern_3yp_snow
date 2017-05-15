function [ x,xcleaned, v, vdot, m ] = Clean(x, xcleaned, v, m,mdot, Fclean, t, D )
%Work out the forces on the device
vdot = - D/m + (1/m)*Fclean;
%Increment the velocity and position
v = v +vdot * t;
x = x + v * t + 0.5 * vdot *t^2;
%Increment the length cleaned
xcleaned = GetCleaned(xcleaned,v,vdot,t);
%Decrement the mass of the device
m = m - mdot*t; 
end

