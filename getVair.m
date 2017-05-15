function [ Vair ] = getVair( v,vdot,Refv, Vair, Kp, Kd, t, x, n )
%GETVAIR Summary of this function goes here
%   Detailed explanation goes here

%%%%% Have the acceleration of the device, use that for the differential
%%%%% controller

Vairmax = 8;
Vairmin = 0;

Ki = -0.00;

error1 = Refv - v;
error2 = -vdot ;
error3 = Refv * t * n- x;

Vair = Vair + error1* Kp + error2 * Kd + error3  * Ki;
%Vair = error1* Kp + error2 * Kd + error3  * Ki;

if Vair > Vairmax
    Vair = Vairmax;
end

if Vair < Vairmin
    Vair = Vairmin;
end
    


end

