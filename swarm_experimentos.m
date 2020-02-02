% C�digo elaborado con base en el curso
% "Rob�tica y optimizaci�n inteligente con Octave o Matlab"
% de Udemy 
% Dise�o e Innovaci�n 1
% Gabriela Iriarte Colmenares
% 16009

%% fase 1: init
% Par�metros fijos por el usuario

swarmsize = 10; % tama�o de la poblaci�n (swarm)
dimension = 2;  % Dimensi�n del espacio de b�squeda
gen = 0;        % Iteraci�n inicial
maxgen = 500;    % M�ximo n�mero de iteraciones

max_lim_x = 2;  % L�mites del �rea de b�squeda
min_lim_x = -2;
max_lim_y = 2;
min_lim_y = -2;

porcentaje_error = 1/100;

% Para verificar porcentaje de error    
distancias = zeros(swarmsize, 1); % Init del array con las distancias de cada part�cula a la soluci�n
Xteorica = [1 1; 0 0]; % Soluci�n (primera fila x,y)
search_area = (max_lim_x-min_lim_x)*(max_lim_y-min_lim_y);
distancia_max = sqrt(search_area*porcentaje_error/pi);

% Init del array para graficar el globalbest vs iteraciones
coste = zeros(1,gen);

% Para graficar la superficie y el contour
[X,Y] = meshgrid(-2:0.1:2);
Z = 100*(Y-X.^2).^2+(ones(size(X))-X).^2;

% Para graficar el c�rculo delimitador de soluciones
xcirc = distancia_max * cos(0:pi/50:2*pi) + Xteorica(1,1);
ycirc = distancia_max * sin(0:pi/50:2*pi) + Xteorica(1,2);

% Creaci�n de los vectores
%x = rand(swarmsize, dimension); % vector posicion (swarmsize filas y pos columnas)
x(:,1) = min_lim_x + (max_lim_x-min_lim_x).*rand(swarmsize,1);
x(:,2) = min_lim_y + (max_lim_y-min_lim_y).*rand(swarmsize,1);
v = rand(swarmsize, dimension); % vector aceleraci�n

x_ini = x;
v_ini = v;

% valores �ptimos en la primera generaci�n
cost = costFunction2(x);

localbest = cost;
localp = x;

[globalbest, indx] = min(cost);
globalp=x(indx,:);

% Par�metros a variar
c1 = 0.1;
c2 = 0.9; 
K = 1;

%% fase 2: loop

% PAR�METROS
lim_inf_c2 = 0.1;
lim_sup_c2 = 4;
step_c2 = 0.1;
lim_inf_c1 = lim_inf_c2;
lim_sup_c1 = lim_sup_c2;
step_c1 = step_c2;

% Creaci�n de la celda con sus encabezados

max_corridas = 100;
celda = cell(max_corridas+1,4);
celda{1,2} = 'lineal';
celda{1,3} = 'exp';
celda{1,4} = 'constante';
contc1 = 2;

for val = 1:1:max_corridas
    celda{contc1,1} = num2str(val);
    contc1 = contc1 + 1;
end

contc1 = 2;
contc2 = 2;
for corridas = 2:1:max_corridas+1
    for funcion_w = [1 2 3]
        
        while (gen < maxgen)
            
            gen = gen + 1;
            
            if funcion_w == 1
                w = (maxgen-gen)/maxgen;
            elseif funcion_w == 2
                w = exp(-1*(1-(maxgen-gen)/maxgen));
            elseif funcion_w == 3
                w = 1;
            end
            
            r1 = rand(swarmsize, dimension);% Se cambia en cada iteracion?
            r2 = rand(swarmsize, dimension);
            
            v = K.*(w.*v+c1.*r1.*(localp-x)+c2.*r2.*(ones(swarmsize, 1)*globalp-x));
            
            x = x+v;
            
            % Encontrar nada m�s el m�ximo entre -10 y 10 porque la funci�n oscila.
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
        
        % Verificaci�n de porcentaje de error del algoritmo
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
        
        celda{corridas,contc2} = cumplen_porcentaje_error;
        contc2 = contc2 + 1;
        
    end
    contc2 = 2;
    
    x(:,1) = min_lim_x + (max_lim_x-min_lim_x).*rand(swarmsize,1);
    x(:,2) = min_lim_y + (max_lim_y-min_lim_y).*rand(swarmsize,1);
    v = rand(swarmsize, dimension); % vector aceleraci�n
    
    x_ini = x;
    v_ini = v;
    
end
%%




