%plot_PL_general.m
%coded via Yahui Ji, adapted from Dr. Wu
%Chien-Shiung Wu College, Southeast University
%2018.10.30
%***************************************************************%
clear all
clf
clc
%***************************************************************%
%�����趨
fc=1.5e9; %��Ų�Ƶ��Ϊ1500MHz
d0=100; %�ο�����Ϊ100m
sigma=3; %��Ӱ���������׼��Ϊ3
distance=[1:2:31].^2; %�������
Gt=[1 1 0.5]; %������������
Gr=[1 0.5 0.5]; %������������
Exp=[2 3 6]; %·�����ָ��
%***************************************************************%
%������
for k=1:3
    y_free(k,:)=PL_free(fc,distance,Gt(k),Gr(k)); %���ɿռ�·����� �� ��������������� �ı仯
    y_logdist(k,:)=PL_logdist_or_norm(fc,distance,d0,Exp(k)); %��������·����� �� ·�����ָ�� �ı仯
    y_lognorm(k,:)=PL_logdist_or_norm(fc,distance,d0,Exp(1),sigma); %������̬��Ӱ˥��·����� �� ��ͬ��Ӱ�������ȡֵ �ı仯
end
%***************************************************************%
%��ͼ
figure(1)
semiplot = semilogx(...
distance,y_free(1,:),'.-',...
distance,y_free(2,:),'.-',...
distance,y_free(3,:),'.-',...
'LineWidth',1.0, 'MarkerSize',7);
set(semiplot(1),'Color',[61, 89, 171]/256); %��ɫ
set(semiplot(2),'Color',[0.850980401039124,0.325490206480026,0.0980392172932625]); %��ɫ
set(semiplot(3),'Color',[0.929411768913269 ,0.694117665290833,0.125490203499794]); %��ɫ
grid on;
strLegend = {'$G_t=1$,$G_r=1$',...
'$G_t=1$,$G_r=0.5$',...
'$G_t=0.5$,$G_r=0.5$'};
legend_handle = legend(strLegend);
set(legend_handle,'Interpreter','latex')
title(['Free Path-loss Model,{\itf_c}=',num2str(fc/1e6),'MHz'])
xlabel ('Distance [m]'); ylabel ('Path-loss [dB]');
hold on

figure(2)
semiplot = semilogx(...
distance,y_logdist(1,:),'.-',...
distance,y_logdist(2,:),'.-',...
distance,y_logdist(3,:),'.-',...
'LineWidth',1.0, 'MarkerSize',7);
set(semiplot(1),'Color',[61, 89, 171]/256); %��ɫ
set(semiplot(2),'Color',[0.850980401039124,0.325490206480026,0.0980392172932625]); %��ɫ
set(semiplot(3),'Color',[0.929411768913269 ,0.694117665290833,0.125490203499794]); %��ɫ
grid on;
strLegend = {'$n=2$',...
'$n=3$',...
'$n=6$'};
legend_handle = legend(strLegend);
set(legend_handle,'Interpreter','latex')
title(['Log-distance Path-loss Model,{\itf_c}=',num2str(fc/1e6),'MHz'])
xlabel ('Distance [m]'); ylabel ('Path-loss [dB]');
hold on

figure(3)
semiplot = semilogx(...
distance,y_lognorm(1,:),'.-',...
distance,y_lognorm(2,:),'.-',...
distance,y_lognorm(3,:),'.-',...
distance,y_logdist(1,:),'-',...
'LineWidth',1.0, 'MarkerSize',7);
set(semiplot(1),'Color',[61, 89, 171]/256); %��ɫ
set(semiplot(2),'Color',[0.850980401039124,0.325490206480026,0.0980392172932625]); %��ɫ
set(semiplot(3),'Color',[0.929411768913269 ,0.694117665290833,0.125490203499794]); %��ɫ
set(semiplot(4),'Color',[0 0 0]); %��ɫ
grid on;
strLegend = {'path$1$',...
'path$2$',...
'path$3$',...
'no shadow random variable'};
legend_handle = legend(strLegend);
set(legend_handle,'Interpreter','latex')
title(['Log-normal Path-loss Model,{\itf_c}=',num2str(fc/1e6),'MHz,\sigma=',num2str(sigma),'dB'])
xlabel ('Distance [m]'); ylabel ('Path-loss [dB]');
hold on
%***************************************************************%