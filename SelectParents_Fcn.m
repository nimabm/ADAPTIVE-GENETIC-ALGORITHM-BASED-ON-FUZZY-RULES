function Parents = SelectParents_Fcn(Cost,nParents)

cmin = min(Cost);
Cost = Cost-cmin;
Cost = Cost/sum(Cost(:));

Parents = zeros(1,nParents);
wheel = cumsum(Cost);
for l = 1:nParents
    r = rand;
    for k = 1:length(wheel)
        if r < wheel(k)
            Parents(l) = k;
            break;
        end
    end
end
