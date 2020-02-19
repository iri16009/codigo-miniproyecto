function g = goal(funcion_costo)
    
    if (funcion_costo == "Banana")
        g = [1 1];
    elseif (funcion_costo == "Ackley")
        g = [0 0];
    elseif (funcion_costo == "Rastrigin")
        g = [0 0];
    elseif (funcion_costo == "Peaks")
        g = [0.2283 -1.626];
    elseif (funcion_costo == "Booth")
        g = [1 3];
    elseif (funcion_costo == "APF")
        g = [4 6];
    end

end