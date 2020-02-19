%% Prueba del Artificial Potential Field (APF)
% Gabriela Iriarte
% 11/02/2020

%% Potencial atractor
dstar_goal = 1; % Threshold
xi = 2; % attraction gain
goal = [1 1]; % punto goal x,y
gridx = 50; % Cuadrícula en x
gridy = 50; % Cuadrícula en y

% Calculamos la cuadrícula de la 'mesa'
[X,Y] = meshgrid(1:1:gridx,1:1:gridy);
Xcolumna = reshape(X, [gridx*gridy 1]);
Ycolumna = reshape(Y, [gridx*gridy 1]);
XY = [Xcolumna Ycolumna];
XY_goal = [goal;XY];
[XYrows, XYcols] = size([Xcolumna Ycolumna]);
scatter(XY(:,1),XY(:,2));
distancias = pdist(XY_goal);
d = distancias(1:XYrows); % Distancia de q a qgoal donde q son todos los puntos del meshgrid
Uatt = 0.5.*xi.*(d <= dstar_goal).*(d.^2) + dstar_goal.*xi.*not(d <= dstar_goal).*d - 0.5*dstar_goal^2;

subplot(1,3,1);
surf(X,Y,reshape(Uatt, [gridy gridx]))

%% Potencial repulsor
radio_Obstaculo = 2;
Obst = [10,10];
Qstar = 1;
eta = 1;
dist_obst = pdist([Obst; XY]);
D = dist_obst(1:XYrows)-(radio_Obstaculo+Qstar);
D = D.*(D>0)+not(D>0)*0.1;
Urep = (0.5*eta*(D.^(-1)-1/Qstar).^2).*(D<=Qstar);
subplot(1,3,2);
surf(X,Y,reshape(Urep, [gridy gridx]))

%% Potencial completo
subplot(1,3,3);
surf(X,Y,reshape(Urep, [gridy gridx])+reshape(Uatt, [gridy gridx]))



