function [ xcleaned ] = GetCleaned( xcleaned, v, vdot , t)
%GETCLEANED 

if v<3;
    xcleaned = xcleaned + v * t + 0.5 * vdot *t^2;
end


end

