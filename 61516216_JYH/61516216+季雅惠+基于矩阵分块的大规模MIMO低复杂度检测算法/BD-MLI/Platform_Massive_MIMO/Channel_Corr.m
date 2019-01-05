%�Ľ������MIMO�ŵ�
%�ο���Parametrization Based Limited Feedback Design for Correlated MIMO
%Channels Using New Statistical Models��
%����
function hh = Channel_Corr(RS,TS,ratio1,ratio2)
% ���룺
%       RS������������
%       TS������������
%       ratio�� �ŵ����ϵ����0-1
%       phase:�����ŵ�ģ���е�һ��ϵ��
% �����
%       hh: BSxMS����ŵ�
h = sqrt(1/2)*(randn(RS,TS)+1i*randn(RS,TS));
if nargin<3        %�������������ŵ�����
    hh=h;
    return;
end
%%---------------------------------------------------
if ratio1~=0
R=eye(RS);
%�û���ؾ����γ�,R(p,q)
for p = 1:RS
    for q=(p+1):RS           %q>p
        R(p,q) = (exp(1i*rand*pi/2)*ratio1)^(q-p);
    end
end
R = R + R';       %����Գ�
R = R - eye(RS);
C = Cholesky(R);   
%C = chol(R); 
else
    C=eye(RS);
end%%cholesky�ֽ�õ������Ǿ���
%%--------------------------------------------------------
%�û���ؾ����γ�,R(p,q)
%%-----------------------------------------------------
if ratio2~=0
T=eye(TS);
for p = 1:TS
    for q=(p+1):TS           %q>p
        T(p,q) = (exp(1i*rand*pi/2)*ratio2)^(q-p);
    end
end
T = T + T';       %����Գ�
T = T - eye(TS);
L = Cholesky(T);  
else
    L=eye(TS);
end%%cholesky�ֽ�õ������Ǿ���
%%----------------------------------------------------
%���ŵ����������
   hh = C*h*L;
   if(ratio1==0&&ratio2==0)
       hh=h;
   end
   %hh=h;
end