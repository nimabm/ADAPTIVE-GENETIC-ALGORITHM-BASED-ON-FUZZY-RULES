function MutatPop = Mutation_Fcn(C,VarMax,VarMin,t,T)

M = VarMax;
m = VarMin;
r = rand;
l = length(C);
indxi = randi(l);
Ci = C(indxi);
b = 1/l;

Ci1 = Ci + (M-Ci)   * (1-r^((1-t/T)^b));
Ci2 = Ci - (M-Ci-m) * (1-r^((1-t/T)^b));
C1 = C;
C2 = C;
C1(indxi) = Ci1;
C2(indxi) = Ci2;
MutatPop = [C1;C2];
