%%
%close all
clearvars
clc

load('solutions/sol_capeqm1')

times  = csvread('capeqm1/capeqm1_csv_snw_time.csv', 1,1) ;

for i = 1:1
    if (times(i) < 1000)
     sol_capeqm1_num{i} = csvread(['capeqm1/capeqm1_csv_snw_' , num2str(times(i),'%04d'),'.csv'],1,1) ;
    else
         sol_capeqm1_num{i} = csvread(['capeqm1/capeqm1_csv_snw_' , int2str(times(i)),'.csv'],1,1) ;
    end
end


figure
hold on
plot(sol_capeqm1(:,1), sol_capeqm1(:,2), 'k-', 'linewidth', 2)
plot(sol_capeqm1_num{1}(:,2), 1-sol_capeqm1_num{1}(:,1), 'ko', 'linewidth', 2)

plot(sol_capeqm1(:,3), sol_capeqm1(:,4), 'r-', 'linewidth', 2)
plot(sol_capeqm1(:,5), sol_capeqm1(:,6), 'b-', 'linewidth', 2)
plot(sol_capeqm1(:,7), sol_capeqm1(:,8), 'g-', 'linewidth', 2)
plot(sol_capeqm1(:,9), sol_capeqm1(:,10), 'm-', 'linewidth', 2)

% plot(sol_capeqm1_num{2}(:,2), 1-sol_capeqm1_num{2}(:,1), 'ro', 'linewidth', 2)
% plot(sol_capeqm1_num{3}(:,2), 1-sol_capeqm1_num{3}(:,1), 'bo', 'linewidth', 2)
% plot(sol_capeqm1_num{4}(:,2), 1-sol_capeqm1_num{4}(:,1), 'go', 'linewidth', 2)
% plot(sol_capeqm1_num{5}(:,2), 1-sol_capeqm1_num{5}(:,1), 'mo', 'linewidth', 2)
title('Case 1', 'Interpreter', 'Latex', 'fontsize', 18)
legend('Analytical', 'Numerical','location', 'northeast', 'Interpreter', 'Latex', 'fontsize', 18)
xlabel('$X$ [-]', 'Interpreter', 'Latex', 'fontsize', 18)
ylabel('$S_{nw} [-]$', 'Interpreter', 'Latex', 'fontsize', 18)
axis([-1 1 0 1])
grid on
ytickformat('%.1f')
xtickformat('%.1f')
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',16)
%%

%close all
clearvars
clc


load('solutions/sol_capeqm1')

times  = csvread('capeqm1/capeqm1_csv_snw_time.csv', 1,1) ;

for i = 1:5
    
    if (times(i) < 1000)
     sol_capeqm1_num{i} = csvread(['capeqm1/capeqm1_csv_snw_' , num2str(times(i),'%04d'),'.csv'],1,1) ;
    else
         sol_capeqm1_num{i} = csvread(['capeqm1/capeqm1_csv_snw_' , int2str(times(i)),'.csv'],1,1) ;
    end
end


figure
hold on
plot(sol_capeqm1(:,1), sol_capeqm1(:,2), 'k-', 'linewidth', 2)
plot(sol_capeqm1_num{1}(:,2), 1-sol_capeqm1_num{1}(:,1), 'ko', 'linewidth', 2)

plot(sol_capeqm1(:,3), sol_capeqm1(:,4), 'r-', 'linewidth', 2)
plot(sol_capeqm1(:,5), sol_capeqm1(:,6), 'b-', 'linewidth', 2)
plot(sol_capeqm1(:,7), sol_capeqm1(:,8), 'g-', 'linewidth', 2)
plot(sol_capeqm1(:,9), sol_capeqm1(:,10), 'm-', 'linewidth', 2)

plot(sol_capeqm1_num{2}(:,2), 1-sol_capeqm1_num{2}(:,1), 'ro', 'linewidth', 2)
plot(sol_capeqm1_num{3}(:,2), 1-sol_capeqm1_num{3}(:,1), 'bo', 'linewidth', 2)
plot(sol_capeqm1_num{4}(:,2), 1-sol_capeqm1_num{4}(:,1), 'go', 'linewidth', 2)
plot(sol_capeqm1_num{5}(:,2), 1-sol_capeqm1_num{5}(:,1), 'mo', 'linewidth', 2)
title('Case 1', 'Interpreter', 'Latex', 'fontsize', 18)
legend('Analytical', 'Numerical','location', 'northeast', 'Interpreter', 'Latex', 'fontsize', 18)
xlabel('$X$ [-]', 'Interpreter', 'Latex', 'fontsize', 18)
ylabel('$S_{nw} [-]$', 'Interpreter', 'Latex', 'fontsize', 18)
axis([-1 1 0 1])
grid on
ytickformat('%.1f')
xtickformat('%.1f')
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',16)

%%
   figure1 = figure('Renderer', 'painters', 'Position', [700,500,1000,200]);
hold on
for i = 5
len = size(sol_capeqm1_num{i}, 1);
plot(sol_capeqm1_num{i}(:,2),zeros(1,len), 'o-', 'linewidth', 2, 'markersize', 3)
end
set(gca,'ytick',[])
grid on
xtickformat('%.1f')
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',16)
xlabel('$X$ [-]', 'Interpreter', 'Latex', 'fontsize', 18)


dx = abs(sol_capeqm1_num{i}(2:end,2) -  sol_capeqm1_num{i}(1:end-1,2))

 %%



close all
clearvars
clc

load('solutions/sol_capeqm4')

sol_capeqm4_num{1} = csvread('capeqm4/capeqm4_csv_snw_1825.csv',1,1) ;
sol_capeqm4_num{2} = csvread('capeqm4/capeqm4_csv_snw_5416.csv',1,1) ;
sol_capeqm4_num{3} = csvread('capeqm4/capeqm4_csv_snw_10841.csv',1,1) ;
sol_capeqm4_num{4} = csvread('capeqm4/capeqm4_csv_snw_18320.csv',1,1) ;
sol_capeqm4_num{5} = csvread('capeqm4/capeqm4_csv_snw_31284.csv',1,1) ;

figure
hold on
plot(sol_capeqm4(:,1), sol_capeqm4(:,2), 'k-', 'linewidth', 2)
plot(sol_capeqm4(:,3), sol_capeqm4(:,4), 'r-', 'linewidth', 2)
plot(sol_capeqm4(:,5), sol_capeqm4(:,6), 'b-', 'linewidth', 2)
plot(sol_capeqm4(:,7), sol_capeqm4(:,8), 'g-', 'linewidth', 2)
plot(sol_capeqm4(:,9), sol_capeqm4(:,10), 'm-', 'linewidth', 2)

plot(sol_capeqm4_num{1}(:,2), 1-sol_capeqm4_num{1}(:,1), 'ko', 'linewidth', 2)
plot(sol_capeqm4_num{2}(:,2), 1-sol_capeqm4_num{2}(:,1), 'ro', 'linewidth', 2)
plot(sol_capeqm4_num{3}(:,2), 1-sol_capeqm4_num{3}(:,1), 'bo', 'linewidth', 2)
plot(sol_capeqm4_num{4}(:,2), 1-sol_capeqm4_num{4}(:,1), 'go', 'linewidth', 2)
plot(sol_capeqm4_num{5}(:,2), 1-sol_capeqm4_num{5}(:,1), 'mo', 'linewidth', 2)
title('Case 4')
 legend('Numerical', 'Analytical')
 xlabel('x')
 ylabel('S')
 axis([-1 1 0 1])

 %%

 load('solutions/sol_capeqm3')

sol_capeqm3_num{1} = csvread('capeqm3/capeqm3_csv_snw_0197.csv',1,1) ;
sol_capeqm3_num{2} = csvread('capeqm3/capeqm3_csv_snw_0425.csv',1,1) ;
sol_capeqm3_num{3} = csvread('capeqm3/capeqm3_csv_snw_0679.csv',1,1) ;
sol_capeqm3_num{4} = csvread('capeqm3/capeqm3_csv_snw_1002.csv',1,1) ;
sol_capeqm3_num{5} = csvread('capeqm3/capeqm3_csv_snw_1546.csv',1,1) ;

figure
hold on
plot(sol_capeqm3(:,1), sol_capeqm3(:,2), 'k-', 'linewidth', 2)
plot(sol_capeqm3(:,3), sol_capeqm3(:,4), 'r-', 'linewidth', 2)
plot(sol_capeqm3(:,5), sol_capeqm3(:,6), 'b-', 'linewidth', 2)
plot(sol_capeqm3(:,7), sol_capeqm3(:,8), 'g-', 'linewidth', 2)
plot(sol_capeqm3(:,9), sol_capeqm3(:,10), 'm-', 'linewidth', 2)

plot(sol_capeqm3_num{1}(:,2), 1-sol_capeqm3_num{1}(:,1), 'ko', 'linewidth', 2)
plot(sol_capeqm3_num{2}(:,2), 1-sol_capeqm3_num{2}(:,1), 'ro', 'linewidth', 2)
plot(sol_capeqm3_num{3}(:,2), 1-sol_capeqm3_num{3}(:,1), 'bo', 'linewidth', 2)
plot(sol_capeqm3_num{4}(:,2), 1-sol_capeqm3_num{4}(:,1), 'go', 'linewidth', 2)
plot(sol_capeqm3_num{5}(:,2), 1-sol_capeqm3_num{5}(:,1), 'mo', 'linewidth', 2)
title('Case 3')
 legend('Numerical', 'Analytical')
 xlabel('x')
 ylabel('S')
 axis([-1 1 0 1])

 %%

load('solutions/sol_capeqm2')

sol_capeqm2_num{1} = csvread('capeqm2/capeqm2_csv_snw_0718.csv',1,1) ;
sol_capeqm2_num{2} = csvread('capeqm2/capeqm2_csv_snw_1746.csv',1,1) ;
sol_capeqm2_num{3} = csvread('capeqm2/capeqm2_csv_snw_3037.csv',1,1) ;
sol_capeqm2_num{4} = csvread('capeqm2/capeqm2_csv_snw_4527.csv',1,1) ;
sol_capeqm2_num{5} = csvread('capeqm2/capeqm2_csv_snw_6717.csv',1,1) ;

figure
hold on
plot(sol_capeqm2(:,1), sol_capeqm2(:,2), 'k-', 'linewidth', 2)
plot(sol_capeqm2(:,3), sol_capeqm2(:,4), 'r-', 'linewidth', 2)
plot(sol_capeqm2(:,5), sol_capeqm2(:,6), 'b-', 'linewidth', 2)
plot(sol_capeqm2(:,7), sol_capeqm2(:,8), 'g-', 'linewidth', 2)
plot(sol_capeqm2(:,9), sol_capeqm2(:,10), 'm-', 'linewidth', 2)

plot(sol_capeqm2_num{1}(:,2), 1-sol_capeqm2_num{1}(:,1), 'ko', 'linewidth', 2)
plot(sol_capeqm2_num{2}(:,2), 1-sol_capeqm2_num{2}(:,1), 'ro', 'linewidth', 2)
plot(sol_capeqm2_num{3}(:,2), 1-sol_capeqm2_num{3}(:,1), 'bo', 'linewidth', 2)
plot(sol_capeqm2_num{4}(:,2), 1-sol_capeqm2_num{4}(:,1), 'go', 'linewidth', 2)
plot(sol_capeqm2_num{5}(:,2), 1-sol_capeqm2_num{5}(:,1), 'mo', 'linewidth', 2)
title('Case 2')
 legend('Numerical', 'Analytical')
 xlabel('x')
 ylabel('S')
 axis([-1 1 0 1])
