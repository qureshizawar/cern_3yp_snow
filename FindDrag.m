function D =  FindDrag(Vair, v, m)

mu = 0.06;
g = 9.81;
    %Variance of wind
    var = 0.05*v;
    Dfric = mu * m *g;
    
    
   Drag = sqrt(var)*rand(1);
   
   V = Vair - v;
    
    if (V < 0) %Drag follows Solidworks model solution
        Drag = Drag + 0.0132*V^2;
        %Include the effect of wind
    end
    
    if v > 0
        D = Dfric + Drag;
    else
        D =0;
    end

end
