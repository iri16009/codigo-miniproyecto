% Código elaborado con base en el curso
% "Robótica y optimización inteligente con Octave o Matlab"
% de Udemy
% Diseño e Innovación 1
% Gabriela Iriarte Colmenares
% 16009

%% fase 1: init
% Parámetros fijos por el usuario
% La función de costo puede ser:
% "Banana"
% "Ackley"
% "Rastrigin"
% "Peaks"
% "Booth"

funcion_costo = "Ackley";

swarmsize = 10; % tamaño de la población (swarm)
dimension = 2;  % Dimensión del espacio de búsqueda
gen = 0;        % Iteración inicial
maxgen = 60;    % Máximo número de iteraciones
g = goal(funcion_costo);

if (funcion_costo == "Booth")
    max_lim_x = 4;  % Límites del área de búsqueda
    min_lim_x = -4;
    max_lim_y = 4;
    min_lim_y = -4;
else
    max_lim_x = 2;  % Límites del área de búsqueda
    min_lim_x = -2;
    max_lim_y = 2;
    min_lim_y = -2;
end



max_v = (max_lim_x-min_lim_x)/5;

porcentaje_error = 1/100;

% Para verificar porcentaje de error
distancias = zeros(swarmsize, 1); % Init del array con las distancias de cada partícula a la solución
Xteorica = [g; 0 0]; % Solución (primera fila x,y)
search_area = (max_lim_x-min_lim_x)*(max_lim_y-min_lim_y);
distancia_max = sqrt(search_area*porcentaje_error/pi);

% Init del array para graficar el globalbest vs iteraciones
coste = zeros(1,gen);

% Para graficar la superficie y el contour
[X,Y,Z] = PSO_contour(funcion_costo);

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
cost = costFunction2(x,funcion_costo);

localbest = cost;
localp = x;

[globalbest, indx] = min(cost);
globalp=x(indx,:);

% Parámetros a variar
phi1 = 0.4;
phi2 = 3.7;
phi = phi1 + phi2;
K = 2/abs(2-phi-sqrt(phi^2-4*phi));
c1 = phi1*K;
c2 = phi2*K;
funcion_w = 'lineal';

%% fase 2: loop
while (gen < maxgen)
    
    gen = gen + 1;
    
    if strcmp(funcion_w,'lineal')
        w = -0.5/maxgen + 0.9;%(maxgen-gen)/maxgen;
    elseif strcmp(funcion_w,'exp')
        w = exp(-1*(1-(maxgen-gen)/maxgen));
    elseif strcmp(funcion_w,'constante')
        w = 1;
    end
    
    r1 = rand(swarmsize, dimension);% Se cambia en cada iteracion?
    r2 = rand(swarmsize, dimension);
    
    v = K.*(w.*v+c1.*r1.*(localp-x)+c2.*r2.*(ones(swarmsize, 1)*globalp-x));
    
    % Clamping de la velocidad
    overlimitvx = v(:,1) <= max_v;
    underlimitvx = v(:,1) >= -1*max_v;
    v(:,1) = v(:,1).*overlimitvx + not(overlimitvx)*max_v;
    v(:,1) = v(:,1).*underlimitvx + not(underlimitvx)*-1*max_v;
    
    overlimitvy = v(:,2) <= max_v;
    underlimitvy = v(:,2)>=-1*max_v;
    v(:,2) = v(:,2).*overlimitvy + not(overlimitvy)*max_v;
    v(:,2) = v(:,2).*underlimitvy + not(underlimitvy)*-1*max_v;
    
    x = x+v;
    
    % Clamping de la posición
    overlimitx = x(:,1) <= max_lim_x;
    underlimitx = x(:,1) >= min_lim_x;
    x(:,1) = x(:,1).*overlimitx + not(overlimitx)*max_lim_x;
    x(:,1) = x(:,1).*underlimitx + not(underlimitx)*min_lim_x;
    
    overlimity = x(:,2) <= max_lim_y;
    underlimity = x(:,2)>=min_lim_y;
    x(:,2) = x(:,2).*overlimity + not(overlimity)*max_lim_y;
    x(:,2) = x(:,2).*underlimity + not(underlimity)*min_lim_y;
    
    cost = costFunction2(x,funcion_costo);
    
    bestcost = cost < localbest;
    localbest = localbest.*not(bestcost)+cost.*bestcost;
    localp(bestcost,:) = x(bestcost,:);
    
    [new_globalbest, indx] = min(localbest);
    
    if new_globalbest < globalbest
        globalp = x(indx,:);
        globalbest = new_globalbest;
    end
    
    coste(1,gen) = globalbest;
    
    %% Gráfica/Animación
    
    subplot(1,2,1);
    plot(coste(1:gen),'r'),grid on,xlabel('Number of generation'),ylabel('Global cost'),title('Parameter identification of nonlinear dynamic systems');
    subplot(1,2,2);
    scatter(x(:,1), x(:,2),20,'filled', 'k');
    hold on
    plot(xcirc, ycirc,'k--');
    mytitleText = ['\phi _1= ',num2str(phi1),' \phi _2 = ', num2str(phi2),' K = ', num2str(K), ' w = ', funcion_w];
    title(mytitleText,'Interpreter','tex' );
    contour(X,Y,Z,50)
    scatter(g(1), g(2),80, 'r','x','LineWidth',1.5);
    hold off
    drawnow;
    pause(0.1);
    filename = sprintf('Ackley_img_%d.jpg', gen) ;
    saveas(gcf, filename, 'png')
end


%% Verificación de porcentaje de error del algoritmo

cumplen_porcentaje_error = 0;
for p = 1:swarmsize
    Xteorica(2,:) = x(p,:);
    distancias(p) = pdist(Xteorica);
    if (distancias(p) <= distancia_max)
        cumplen_porcentaje_error = cumplen_porcentaje_error + 1;
    end
end

