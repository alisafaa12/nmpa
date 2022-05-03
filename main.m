%_________________________________________________________________________
%  Marine Predators Algorithm source code (Developed in MATLAB R2015a)
%
%  programming: Afshin Faramarzi & Seyedali Mirjalili
%
% paper:
%  A. Faramarzi, M. Heidarinejad, S. Mirjalili, A.H. Gandomi, 
%  Marine Predators Algorithm: A Nature-inspired Metaheuristic
%  Expert Systems with Applications
%  DOI: doi.org/10.1016/j.eswa.2020.113377
%  
%  E-mails: afaramar@hawk.iit.edu            (Afshin Faramarzi)
%           muh182@iit.edu                   (Mohammad Heidarinejad)
%           ali.mirjalili@laureate.edu.au    (Seyedali Mirjalili) 
%           gandomi@uts.edu.au               (Amir H Gandomi)
%_________________________________________________________________________

% --------------------------------------------
% fobj = @YourCostFunction
% dim = number of your variables
% Max_iteration = maximum number of iterations
% SearchAgents_no = number of search agents
% lb=[lb1,lb2,...,lbn] where lbn is the lower bound of variable n
% ub=[ub1,ub2,...,ubn] where ubn is the upper bound of variable n
% ---------------------------------------------------------

addpath('SSA','MVO','MFO','GWO','DE');

clear all
clc
format long
SearchAgents_no=25; % Number of search agents
N=25;
% Function_name='F7';
Function_name='F24';

% load the parameters
global Bandwidth; Bandwidth = 10*1e6; % MHz --> Hz
% dBm  -174dBm/Hz
global Noise; Noise = -124; Noise=10^(Noise/10);        
% power limits - dBm
global p_max; p_max = 20; p_max=10.^(p_max/10)/1000;
% Number of users
global Num_User; Num_User = 20;
% constant to guarantee non-negativity of the transmitted signal and the
% transmitted optical intensity
Const = 10;
delta = 3*sqrt(5)/5;
global C_no; C_no = Const/delta;    

% create the hannel gain
noRealization = 5;
PathLoss_Set = zeros(noRealization,Num_User);
for i = 1:noRealization
    PathLoss_Set(i,:) = bs_user_distribution();
end

% define maximum number of iterations and problem dimensionality
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
Max_iteration=500; % Maximum number of iterations
% dim=100;
global PathLoss_BS_User;

Best_score1 = zeros(1,noRealization);
sumrate = zeros(1,noRealization);
minrate = zeros(1,noRealization);
logsumrate = zeros(1,noRealization);
rate = zeros(noRealization,Num_User);
for i=1:noRealization
    PathLoss_BS_User = PathLoss_Set(i,:);
    [Best_score1(1,i),Best_pos1,Convergence_curve1,NMPA_time(1,i)]=NMPA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
    % note that the fitness function is negative log sum rate. Other
    % metrics can be calculated based on the best power allocation fined by
    % the NMPA algorithm: logsumrate, sumrate, and minrate.
    power = Best_pos1;
    rate(i,:) = ratecalculate(power, PathLoss_BS_User, Num_User, Noise);
    sumrate(1,i) = sum(rate(i,:));
    minrate(1,i) = min(rate(i,:));
    % negate the objective value (minimization --> maximization problem)
    logsumrate(1,i) = -Best_score1(1,i);
    
    
%   [Best_score(1,i),Best_pos,Convergence_curve,MPA_time(1,i)]=MPA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
%   [Best_score1(1,i),Best_pos1,Convergence_curve1,NMPA_time(1,i)]=NMPA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
%   [Best_universe_Inflation_rate(1,i),Best_universe,MVO_Convergence_curve,MVO_time(1,i)]=MVO(N,Max_iteration,lb,ub,dim,fobj);
%   [Best_flame_score(1,i),Best_flame_pos,MFO_Convergence_curve,MFO_time(1,i)]=MFO(N,Max_iteration,lb,ub,dim,fobj);
%   [FoodFitness(1,i),FoodPosition,SSA_Convergence_curve,SSA_time(1,i)]=SSA(N,Max_iteration,lb,ub,dim,fobj);
%   [Alpha_score(1,i),Alpha_pos,GWO_Convergence_curve,GWO_time(1,i)]=GWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
%   [BestCost(1,i),PSO_cg_curve,PSO_time(1,i)]=PSO(N,Max_iteration,lb,ub,dim,fobj);
%   [de_BestCost,BestSol(1,i),de_time(1,i)] = de(fobj,dim,SearchAgents_no,Max_iteration,lb,ub);
end

% MPA_m=mean(Best_score);
% MPA_s=std(Best_score);
% MPA_time_AVG=mean(MPA_time);
% MPA_time_STD=std(MPA_time);

NMPA_m=mean(Best_score1);
NMPA_s=std(Best_score1);
NMPA_time_AVG=mean(NMPA_time);
NMPA_time_STD=std(NMPA_time);

% MVO_m=mean(Best_universe_Inflation_rate);
% MVO_s=std(Best_universe_Inflation_rate);

% MFO_m=mean(Best_flame_score);
% MFO_s=std(Best_flame_score);

% SSA_m=mean(FoodFitness);
% SSA_s=std(FoodFitness);

% GWO_m=mean(Alpha_score);
% GWO_s=std(Alpha_score);

% PSO_m=mean(BestCost);
% PSO_s=std(BestCost);

% DE_m=mean(BestSol);
% DE_s=std(BestSol);
%%
% [MPA_ps,hs1,ss1]=ranksum(Best_score1,Best_score);
% [MVO_ps,hs2,ss2]=ranksum(Best_score1,Best_universe_Inflation_rate);
% [MFO_ps,hs3,ss3]=ranksum(Best_score1,Best_flame_score);
% [SSA_ps,hs4,ss4]=ranksum(Best_score1,FoodFitness);
% [GWO_ps,hs5,ss5]=ranksum(Best_score1,Alpha_score);
% [PSO_ps,hs6,ss6]=ranksum(Best_score1,BestCost);
% [DE_ps,hs7,ss7]=ranksum(Best_score1,BestSol);




% % function topology
% figure('Position',[500 400 700 290])
% subplot(1,2,1);
% figure;
% func_plot(Function_name);
% title('Func.13')
% xlabel('x_1');
% ylabel('x_2');
% zlabel([Function_name,'( x_1 , x_2 )'])

% Convergence curve
% subplot(1,2,2);
% semilogy(Convergence_curve,'Color','r','Linewidth',2)
% hold on
% semilogy(Convergence_curve1,'Color','k','Linewidth',2)
% hold on
% semilogy(MVO_Convergence_curve,'Color','b','Linewidth',2)
% hold on
% semilogy(MFO_Convergence_curve,'Color',[1.000000000000000                   0                   0],'Linewidth',2)
% hold on
% semilogy(SSA_Convergence_curve,'Color',[0.800000000000000   1.000000000000000                   0],'Linewidth',2)
% hold on
% semilogy(GWO_Convergence_curve,'Color',[0   1.000000000000000   0.400000000000000],'Linewidth',2)
% hold on
% semilogy(PSO_cg_curve,'Color',[0   0.400000000000000   1.000000000000000],'Linewidth',2)
% hold on
% semilogy(de_BestCost,'Color',[0.800000000000001                   0   1.000000000000000],'Linewidth',2)
% title('Objective space')
% xlabel('Iteration');
% ylabel('Best score obtained so far');
% legend('MPA','NMPA','MVO','MFO','SSA','GWO','PSO','DE');


% display(['The best solution obtained by MPA is : ', num2str(Best_pos,10)]);
% display(['The best optimal value of the objective function found by MPA is : ', num2str(Best_score,10)]);
% disp(sprintf('--------------------------------------'));
