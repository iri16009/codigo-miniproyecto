function cost = costFunction2(x)

% cost = abs(x)+cos(x); % ecuación que representa a la gráfica del ejemplo a la
% que le queremos sacar el mínimo
cost=100*(x(:,2)-x(:,1).^2).^2+(ones(size(x(:,1)))-x(:,1)).^2;

end