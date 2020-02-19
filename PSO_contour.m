function [X1,Y1,Z] = PSO_contour(funcion_costo)
if (funcion_costo == "Banana")
    [X1,Y1] = meshgrid(-2:0.1:2);
    Z=100*(Y1-X1.^2).^2+(ones(size(X1))-X1).^2;
elseif (funcion_costo == "Ackley")
    [X1,Y1] = meshgrid(-2:0.1:2);
    X2 = reshape(X1, [41*41 1]);Y2 = reshape(Y1, [41*41 1]);
    X = [X2 Y2];
    elevado = X.^2;
    sumaxi = -0.2.*sqrt(0.5.*(elevado(:,1)+elevado(:,2)));
    cosenado = cos(2.*pi.*X);
    sumacos = (cosenado(:,1)+cosenado(:,2));
    Z1 = -20.*exp(sumaxi)-exp(0.5.*sumacos)+20+exp(1);
    Z = reshape(Z1, [41 41]);
elseif (funcion_costo == "Rastrigin")
    [X1,Y1] = meshgrid(-2:0.1:2);
    X2 = reshape(X1, [41*41 1]);Y2 = reshape(Y1, [41*41 1]);
    X = [X2 Y2];
    elevado = X.^2;
    cosenado = cos(2.*pi.*X);
    restado = elevado-cosenado;
    Z1 = 20+(restado(:,1)+restado(:,2));
    Z = reshape(Z1, [41 41]);
elseif (funcion_costo == "Peaks")
    [X1,Y1] = meshgrid(-2:0.1:2);
    Z = peaks(X1,Y1);
elseif (funcion_costo == "Booth")
    [X1,Y1] = meshgrid(-4:0.1:4);
    Z=(X1 + 2*Y1-7).^2 + (2*X1+Y1-5).^2;
elseif (funcion_costo == "APF")
    dstar_goal = 1; % Threshold
    xi = 2; % attraction gain
    gridx = 20; % Cuadrícula en x
    gridy = 20; % Cuadrícula en y
    [X,Y] = meshgrid(1:1:gridx,1:1:gridy);
    Xcolumna = reshape(X, [gridx*gridy 1]);
    Ycolumna = reshape(Y, [gridx*gridy 1]);
    XY = [Xcolumna Ycolumna];
    XY_goal = [[4 6];XY];
    [XYrows, ~] = size([Xcolumna Ycolumna]);
    scatter(XY(:,1),XY(:,2));
    distancias = pdist(XY_goal);
    d = distancias(1:XYrows); % Distancia de q a qgoal donde q son todos los puntos del meshgrid
    Uatt = 0.5.*xi.*(d <= dstar_goal).*(d.^2) + dstar_goal.*xi.*not(d <= dstar_goal).*d - 0.5*dstar_goal^2;
    radio_Obstaculo = 2;
    Obst = [10,10];
    Qstar = 1;
    eta = 1;
    dist_obst = pdist([Obst; XY]);
    D = dist_obst(1:XYrows)-(radio_Obstaculo+Qstar);
    D = D.*(D>0)+not(D>0)*0.1;
    Urep = (0.5*eta*(D.^(-1)-1/Qstar).^2).*(D<=Qstar);
    Z = reshape(Urep, [gridy gridx])+reshape(Uatt, [gridy gridx]);
    X1 = X; Y1 = Y;
end
end