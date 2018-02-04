
%% Start of Program
clc, clear, tic
fismat = readfis('AGABFR');

%% Algorithm Parameters
Npop = 100;
MaxPop = 300;
Ngeneration = 100;

Pc = 0.7;
Pm = 0.9;

CrossPercent = 50;
MutatPercent = 10;

CrossNum = round(CrossPercent/100*Npop); 
if mod(CrossNum,2)~=0; 
    CrossNum = CrossNum - 1; 
end
MutatNum = round(MutatPercent/100*Npop);
ElitNum = Npop - CrossNum - MutatNum;

%% Problem Satement
VarMin = 0;
VarMax = 10;
Nvar = 2;
CostFuncName = @Cost_Fcn;

%% Initial Population
Pop = rand(Npop,Nvar) * (VarMax - VarMin) + VarMin;
Cost = feval(CostFuncName,Pop);
[Cost Indx] = sort(Cost,'descend');
Pop = Pop(Indx,:);

%% Initialize prog parameter
BestC = zeros(Ngeneration,1);
MeanC = 0*BestC;

%% Main Loop
for Iter = 1:Ngeneration
    %% Elitism
    ElitPop = Pop(1:ElitNum,:);
    
    %% Cross Over
    CrossPop = zeros(CrossNum,Nvar);
    k = 1;
    ParentIndexes = SelectParents_Fcn(Cost,CrossNum);
    rand_cross=rand(floor(CrossNum/2),1);
    for ii = 1:CrossNum/2
        if rand_cross(ii) > Pc
            Par1Indx = ParentIndexes(ii*2-1);
            Par2Indx = ParentIndexes(ii*2);
            Par1 = Pop(Par1Indx,:);
            Par2 = Pop(Par2Indx,:);
            Son = CrossOver_Fcn(Par1,Par2);
            CrossPop(k:k+1,:) = Son;
            k = k+2;
        end
    end
    CrossPop = CrossPop(1:k-1,:);
    
    %% Mutation
    k = 1;
    indx = randperm(Npop);
    for ii = 1:Npop
        if rand > Pm
            C = Pop(indx(ii),:);
            MutatPop(k:k+1,:) = Mutation_Fcn(C,VarMax,VarMin,Iter,Ngeneration);
            k = k+1;
        end
        if k > MutatNum,break,end
    end
    MutatPop = MutatPop(1:k-1,:);
        
    %% New Population
    Pop = [ElitPop ; CrossPop ; MutatPop;Pop(ElitNum+1:end,:)];
    l = size(Pop,1);
    if l > MaxPop
        Npop = MaxPop;
        Pop = Pop(1:Npop,:);
    else
        Npop = l;
    end
    Cost = feval(CostFuncName,Pop);
    [Cost Indx] = sort(Cost,'descend');
    Pop = Pop(Indx,:);

    %% Algorithm Progress
    varcost = mean(var(Pop));
    dP = evalfis(varcost,fismat);
    Pm = Pm + dP(1);
    Pc = Pc + dP(2);

    if Pc > .9, Pc = .9;
    elseif Pc < .1, Pc = .1;end
    if Pm > .97, Pm = .97;
    elseif Pm < .03, Pm = .03;end

    %% Compute number of CrossOver & Mutation 
    MutatNum = round(MutatPercent/100*Npop);
    CrossNum = round(CrossPercent/100*Npop); 

    %%
    BestC(Iter) = Cost(1);
    MeanC(Iter) = mean(Cost);

    %% Show Result
    plot(BestC(1:Iter),'--r','linewidth',2);
    hold on
    plot(MeanC(1:Iter),'--k','linewidth',2);
    hold off
    figure(gcf)
end
clc, toc, pause(.5)

%% Show final result
% figure
plot(BestC/max(BestC),'--r','linewidth',2);
hold on
plot(MeanC/max(BestC),'--k','linewidth',2);
hold off
figure(gcf)

legend('Best Individual','Mean of Individuals',4)
xlabel('Generations')
ylabel('Normilized Fitness')
ylim([-.2,1.2])

%% Results
disp('----------------------------------------------')
BestSolution = Pop(1,:);
BestCost = Cost(1,:);
disp(['BestSolution = ',num2str(BestSolution)])
disp(['BestCost = ',num2str(BestCost)])
disp('----------------------------------------------')
%% End of Program

