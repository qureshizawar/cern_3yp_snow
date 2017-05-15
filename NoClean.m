function [ x,xcleaned, v, vdot, m ] = NoClean(x,xcleaned,v, m,t, D )
%Work out the forces on the device
vdot = - D/m;
%Increment the velocity and position
v = v +vdot * t;
x = x + v * t + 0.5 * vdot *t^2;
end