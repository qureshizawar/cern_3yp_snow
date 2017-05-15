function [ni] = Delay(x, t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Ratio = x(length(x))/2800;

Delay = Ratio * 30;
Variance = 10;
Delay = Delay + sqrt(Variance)*randn();

if Delay <0
    Delay = 0;
end


ni = Delay /t;
end