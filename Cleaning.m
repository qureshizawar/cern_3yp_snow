function [xcleaned, vcleaned,i,m,vdot, CleanDist, spray] = Cleaning( num, x,L, v, vdot, m, mmin, Fclean, mdot )
%CLEANING Summary of this function goes here
%   Detailed explanation goes here

if num == 1
    vel = 2.9;
    range = 0.1;
    [xcleaned, vcleaned,i,m,vdot, CleanDist, spray] =VelRange(x,L, v, vdot, m, mmin, Fclean, mdot, 0.1, vel, range);
    
elseif num == 2
    [xcleaned,CleanDist, vcleaned,vdot,m, i, spray] =FullOn(x,L, v, vdot, m, mmin, Fclean, mdot, 0.1);
    
elseif num == 3
    T1 = 24.5;
    T2 = 1.5;
    [xcleaned, vcleaned,vdot,m, i, CleanDist, spray] =PulsesCleaned(x,L, v, vdot, m, mmin, Fclean, mdot, 0.1, T1, T2);
    
elseif num == 4
    vel = 3;
    [xcleaned,CleanDist, vcleaned,vdot,m,i, spray] =OffVel(x,L, v, vdot, m, mmin, Fclean, mdot, 0.1, vel);
    
    
else xcleaned = 0;
    vcleaned = v;
    i = 0;
    m = m;
    vdot = vdot;
    CleanDist = 0;
    
end


end

