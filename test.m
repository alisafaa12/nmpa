clc;
clear all;
close all;

Iter=0;
Max_iter=500;

for i=1:Max_iter
%   CF(i)=(1-Iter/Max_iter)^(2*Iter/Max_iter);
%   CF1(i)=4*(1-Iter/Max_iter)^(2*Iter/Max_iter);
  CF1(i)=abs(2*(1-(Iter/Max_iter))-2);
  w1(i)=2*exp(-(6*Iter/Max_iter)^2);
  Iter= Iter+1;
end
figure;
semilogy(CF1,'b','LineWidth',2);
hold on;
semilogy(w1,'k','LineWidth',2);
legend('CF1','w1')
% hold on;
% plot(w1);