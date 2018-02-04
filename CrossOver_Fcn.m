function son = CrossOver_Fcn(Par1,Par2)

son(3,:) = 0.5*Par1 + 0.5*Par2;
son(1,:) = 1.5*Par1 - 0.5*Par2;
son(2,:) = -.5*Par1 + 1.5*Par2;

Cost = Cost_Fcn(son);
[Cost,indx] = sort(Cost,'descend');
son = son(indx(1:2),:);