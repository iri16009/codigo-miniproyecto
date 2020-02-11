%% Prueba del Artificial Potential Field (APT)
% Gabriela Iriarte
% 11/02/2020

%% Potencial atractor
dstar_goal = 1; % Threshold
xi = 1; % attraction gain
goal = [4 4]; % punto goal x,y
gridx = 20; % Cuadrícula en x
gridy = 20; % Cuadrícula en y

% Calculamos la cuadrícula de la 'mesa'
[X,Y] = meshgrid(1:1:gridx,1:1:gridy);
Xcolumna = reshape(X, [gridx*gridy 1]);
Ycolumna = reshape(Y, [gridx*gridy 1]);
XY_goal = [goal;[Xcolumna Ycolumna]];
[XYrows, XYcols] = size([Xcolumna Ycolumna]);
scatter(XY(:,1),XY(:,2));
distancias = pdist(XY_goal);
d = distancias(1:XYrows); % Distancia de q a qgoal donde q son todos los puntos del meshgrid
Uatt = 0.5.*xi.*(d <= dstar_goal).*(d.^2) + dstar_goal.*xi.*not(d <= dstar_goal).*d - 0.5*dstar_goal^2;

mesh(X,Y,reshape(Uatt, [gridx gridy]))

%% Potencial repulsor













