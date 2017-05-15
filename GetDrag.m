function [ D ] = GetDrag( V , m)
    %Coefficient of Friction of ball bearings on pipe
    mu = 0.07;
    g = 9.81;
    %Variance of wind
    var = 0.05*V;
    Dfric = mu * m *g;
    %Drag follows Solidworks model solution
    Drag = 0.0132*V^2;
    %Include the effect of wind
    Drag = Drag + sqrt(var)*rand(1);
    if V > 0
        D = Dfric + Drag;
    else
        D =0;
    end
end