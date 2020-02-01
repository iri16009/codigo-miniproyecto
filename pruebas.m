%% Prueba de distintas funciones para w

 gen = 0; % Iteración inicial
 maxgen = 70; % Máximo número de iteraciones
 swarmsize = 10;
% 
% 
% while (gen<maxgen)
%     
%     gen = gen + 1;
%     %w = (maxgen-gen)/maxgen;
%     w = exp(-1*(1-(maxgen-gen)/maxgen));
%     %w = 0.9-(0.5*(gen/maxgen));
%    
% end

%% Prueba del 5% de aceptación de la respuesta obtenida
gen = maxgen;
distancias = zeros(swarmsize, 1);
Xteorica = [1 1; 0 0];

search_area = 16;
porcentaje_error = 1/100;

distancia_max = sqrt(search_area*porcentaje_error/pi);

cumplen_porcentaje_error = 0;

xcirc = distancia_max * cos(0:pi/50:2*pi) + 1;
ycirc = distancia_max * sin(0:pi/50:2*pi) + 1;
plot(xcirc, ycirc,'k--');


if (gen == maxgen)
    for p = 1:swarmsize
        Xteorica(2,:) = x(p,:);
        distancias(p) = pdist(Xteorica);
        if (distancias(p) <= distancia_max)
            cumplen_porcentaje_error = cumplen_porcentaje_error + 1;
        end
        
    end
end

hola = 'adis';

if hola=='hola'
    disp(44444444)
end


