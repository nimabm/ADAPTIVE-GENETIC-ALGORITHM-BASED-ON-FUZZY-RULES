function Cost = Cost_Fcn(Pop)

l = size(Pop,1);
Cost = zeros(l,1);
R = -3;
for ii = 1:l
    p = Pop(ii,:);
    C = (-p(1)*sin(4*p(1)) - 1.1 * p(2)*sin(2*p(2)));
    V = max([0,-p(1),p(1)-10,-p(2),p(2)-10]);
    Cost(ii) = C + R*V;
end
