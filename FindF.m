function [ F ] = FindF( V)
%FINDF 

F = 0.132* V^2 + 0.0983*V + 0.0132;

if V < 0.01
    F = 0;
end


end

