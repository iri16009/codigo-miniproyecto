function cost = costFunction2(x)

% cost = abs(x)+cos(x); % ecuaci�n que representa a la gr�fica del ejemplo a la
% que le queremos sacar el m�nimo
cost=100*(x(:,2)-x(:,1).^2).^2+(ones(size(x(:,1)))-x(:,1)).^2;

end