% Código elaborado con base en el curso
% "Robótica y optimización inteligente con Octave o Matlab"
% de Udemy 
% Diseño e Innovación 1
% Gabriela Iriarte Colmenares
% 16009

%% fase 1: init
% Parámetros fijos por el usuario

swarmsize = 10; % tamaño de la población (swarm)
dimension = 2;  % Dimensión del espacio de búsqueda
gen = 0;        % Iteración inicial
maxgen = 500;    % Máximo número de iteraciones

max_lim_x = 2;  % Límites del área de búsqueda
min_lim_x = -2;
max_lim_y = 2;
min_lim_y = -2;

porcentaje_error = 5/100;

% Para verificar porcentaje de error    
distancias = zeros(swarmsize, 1); % Init del array con las distancias de cada partícula a la solución
Xteorica = [1 1; 0 0]; % Solución (primera fila x,y)
search_area = (max_lim_x-min_lim_x)*(max_lim_y-min_lim_y);
distancia_max = sqrt(search_area*porcentaje_error/pi);

% Init del array para graficar el globalbest vs iteraciones
coste = zeros(1,gen);

% Para graficar la superficie y el contour
[X,Y] = meshgrid(-2:0.1:2);
Z = 100*(Y-X.^2).^2+(ones(size(X))-X).^2;

% Para graficar el círculo delimitador de soluciones
xcirc = distancia_max * cos(0:pi/50:2*pi) + Xteorica(1,1);
ycirc = distancia_max * sin(0:pi/50:2*pi) + Xteorica(1,2);

% Creación de los vectores
%x = rand(swarmsize, dimension); % vector posicion (swarmsize filas y pos columnas)
x(:,1) = min_lim_x + (max_lim_x-min_lim_x).*rand(swarmsize,1);
x(:,2) = min_lim_y + (max_lim_y-min_lim_y).*rand(swarmsize,1);
v = rand(swarmsize, dimension); % vector aceleración

x_ini = x;
v_ini = v;

% valores óptimos en la primera generación
cost = costFunction2(x);

localbest = cost;
localp = x;

[globalbest, indx] = min(cost);
globalp=x(indx,:);

% Parámetros a variar
c1 = 0:0.1:4;
c2 = 0:0.1:4; 
K = 1;
funcion_w = 'constante';

%% fase 2: loop

% PARÁMETROS
lim_inf_c2 = 0.1;
lim_sup_c2 = 4;
step_c2 = 0.1;
lim_inf_c1 = lim_inf_c2;
lim_sup_c1 = lim_sup_c2;
step_c1 = step_c2;

% Creación de la celda con sus encabezados
% El tamaño de la celda en este caso solo fue definido por el tamaño de los
% límites de c2. Si es necesario que no sea una matriz cuadrada hay que
% modificar el código.

celda = cell((lim_sup_c2-lim_inf_c2)/step_c2+2);
contc1 = 2;
for c2 = lim_inf_c2:step_c2:lim_sup_c2
    celda{1,contc1} = num2str(c2);
    celda{contc1,1} = num2str(c2);
    contc1 = contc1 + 1;
end

contc1 = 2;
contc2 = 2;
for c1= lim_inf_c1:step_c1:lim_sup_c1
    for c2 = lim_inf_c2:step_c2:lim_sup_c2
        
        while (gen < maxgen)
            
            gen = gen + 1;
            
            if strcmp(funcion_w,'lineal')
                w = (maxgen-gen)/maxgen;
            elseif strcmp(funcion_w,'exp')
                w = exp(-1*(1-(maxgen-gen)/maxgen));
            elseif strcmp(funcion_w,'constante')
                w = 1;
            end
            
            r1 = rand(swarmsize, dimension);% Se cambia en cada iteracion?
            r2 = rand(swarmsize, dimension);
            
            v = K.*(w.*v+c1.*r1.*(localp-x)+c2.*r2.*(ones(swarmsize, 1)*globalp-x));
            
            x = x+v;
            
            % Encontrar nada más el máximo entre -10 y 10 porque la función oscila.
            overlimitx = x(:,1) <= max_lim_x;
            underlimitx = x(:,1) >= min_lim_x;
            x(:,1) = x(:,1).*overlimitx + not(overlimitx)*max_lim_x;
            x(:,1) = x(:,1).*underlimitx + not(underlimitx)*min_lim_x;
            
            overlimity = x(:,2) <= max_lim_y;
            underlimity = x(:,2)>=min_lim_y;
            x(:,2) = x(:,2).*overlimity + not(overlimity)*max_lim_y;
            x(:,2) = x(:,2).*underlimity + not(underlimity)*min_lim_y;
            
            cost = costFunction2(x);
            
            bestcost = cost < localbest;
            localbest = localbest.*not(bestcost)+cost.*bestcost;
            localp(bestcost,:) = x(bestcost,:);
            
            [new_globalbest, indx] = min(localbest);
            
            if new_globalbest < globalbest
                globalp = x(indx,:);
                globalbest = new_globalbest;
            end
            
        end
        
        % Verificación de porcentaje de error del algoritmo
        cumplen_porcentaje_error = 0;
        for p = 1:swarmsize
            Xteorica(2,:) = x(p,:);
            distancias(p) = pdist(Xteorica);
            if (distancias(p) <= distancia_max)
                cumplen_porcentaje_error = cumplen_porcentaje_error + 1;
            end
        end
        gen = 0;
        x = x_ini;
        v = v_ini;
        cost = costFunction2(x);
        localbest = cost;
        localp = x;
        [globalbest, indx] = min(cost);
        globalp=x(indx,:);

        celda{contc2,contc1} = cumplen_porcentaje_error;
        contc2 = contc2 +1;
    end
    contc2 = 2;
    contc1 = contc1 + 1;
end




