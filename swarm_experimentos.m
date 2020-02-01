% Código elaborado con base en el curso
% "Robótica y optimización inteligente con Octave o Matlab"
% de Udemy 
% Diseño e Innovación 1
% Gabriela Iriarte Colmenares
% 16009

%% fase 1: init

swarmsize = 10; % tamaño de la población (swarm)
dimension = 2;  % Dimensión del espacio de búsqueda
% Coeficientes de aceleración de 0 a 4. Generalmente son iguales y tienen
% el valor de 2.

c1 = 1;
c2 = 1; 

gen = 0; % Iteración inicial
maxgen = 70; % Máximo número de iteraciones

x = rand(swarmsize, dimension); % vector posicion (swarmsize filas y pos columnas)
%x = randi(2,swarmsize, dimension); % vector posicion (swarmsize filas y pos columnas)
v = rand(swarmsize, dimension); % vector aceleración

%c = 2.7298; % Para garantizar convergencia
K = 0.8;

% valores óptimos en la primera generación
cost = costFunction2(x);

localbest = cost;
localp = x;

[globalbest, indx] = min(cost); % cuando necesitemos minimizar
globalp=x(indx,:);
coste = zeros(1,gen);

[X,Y]=meshgrid(-2:0.1:2);
Z=100*(Y-X.^2).^2+(ones(size(X))-X).^2;
  
xcirc = distancia_max * cos(0:pi/50:2*pi) + 1;
ycirc = distancia_max * sin(0:pi/50:2*pi) + 1;


%% fase 2: loop

while (gen < maxgen)
    
    gen = gen + 1;
    
    if funcion_w == 'lineal'
        w = (maxgen-gen)/maxgen;
    elseif funcion_w == 'exponencial'
        w = exp(-1*(1-(maxgen-gen)/maxgen));
    end
    
    r1 = rand(swarmsize, dimension);% Se cambia en cada iteracion?
    r2 = rand(swarmsize, dimension);

    v = K.*(w.*v+c1.*r1.*(localp-x)+c2.*r2.*(ones(swarmsize, 1)*globalp-x));
    
    x = x+v;
    
    % Encontrar nada más el máximo entre -10 y 10 porque la función oscila.
    overlimit = x(:,1) <= 2;
    underlimit=x(:,1)>=-2;
    x(:,1) = x(:,1).*overlimit + not(overlimit)*2;
    x(:,1) = x(:,1).*underlimit + not(underlimit)*-2;
    
    overlimit = x(:,2) <= 2;
    underlimit=x(:,2)>=-2;
    x(:,2) = x(:,2).*overlimit + not(overlimit)*2;
    x(:,2) = x(:,2).*underlimit + not(underlimit)*-2;
    
    cost = costFunction2(x);
    
  bestcost = cost < localbest;
  localbest = localbest.*not(bestcost)+cost.*bestcost;
  localp(bestcost,:) = x(bestcost,:); 

   [new_globalbest, indx]=min(localbest);
    
    if new_globalbest<globalbest
     globalp=x(indx,:);
     globalbest=new_globalbest;
    end
    
    coste(1,gen)=globalbest;
    subplot(1,2,1);
    plot(coste(1:gen),'r'),grid on,xlabel('Number of generation'),ylabel('Global cost'),title('Parameter identification of nonlinear dynamic systems');
    subplot(1,2,2);
    scatter(x(:,1), x(:,2),20,'filled', 'k');
    hold on
    plot(xcirc, ycirc,'k--');
    mytitleText = ['c_1= ',num2str(c1),' c_2 = ', num2str(c2),' K = ', num2str(K)];
    title(mytitleText,'Interpreter','tex' );
    contour(X,Y,Z,50)
    scatter(1, 1,80, 'r','x','LineWidth',1.5);
    hold off
    drawnow;
    pause(0.1);
end

distancias = zeros(swarmsize, 1);
Xteorica = [1 1; 0 0];

search_area = 16;
porcentaje_error = 1/100;

distancia_max = sqrt(search_area*porcentaje_error/pi);

cumplen_porcentaje_error = 0;

for p = 1:swarmsize
        Xteorica(2,:) = x(p,:);
        distancias(p) = pdist(Xteorica);
        if (distancias(p) <= distancia_max)
            cumplen_porcentaje_error = cumplen_porcentaje_error + 1;
        end
end

