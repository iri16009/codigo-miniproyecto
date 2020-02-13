function cost = costFunction2(x, funcion_costo)

% cost = abs(x)+cos(x); % ecuación que representa a la gráfica del ejemplo a la
% que le queremos sacar el mínimo

if (funcion_costo == "Banana")
    cost=100*(x(:,2)-x(:,1).^2).^2+(ones(size(x(:,1)))-x(:,1)).^2;
elseif (funcion_costo == "Ackley")
    elevado = x.^2;
    sumaxi = -0.2.*sqrt(0.5.*(elevado(:,1)+elevado(:,2)));
    cosenado = cos(2.*pi.*x);
    sumacos = (cosenado(:,1)+cosenado(:,2));
    cost = -20.*exp(sumaxi)-exp(0.5.*sumacos)+20+exp(1);
elseif (funcion_costo == "Rastrigin")
    elevado = x.^2;
    cosenado = cos(2.*pi.*x);
    restado = elevado-cosenado;
    cost = 20+(restado(:,1)+restado(:,2));
elseif (funcion_costo == "Peaks")
    cost = peaks(x(:,1),x(:,2));
end




end