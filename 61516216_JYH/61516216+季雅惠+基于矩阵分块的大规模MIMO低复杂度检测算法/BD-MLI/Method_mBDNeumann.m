 function outputA = Method_mBDNeumann(inputA,ka2,ka1,bl)
% inputA=cW;
% ka1=4;
% bl=4;

%˫�����

%ÿ��ֿ����ά��ȷ��
dimA=size(inputA);
dimD1bl=dimA(1,1)/2;

%��С�ֿ���������Ĵ洢
bln=dimA(1,1)/bl;%��С�ֿ������Ŀ
D2bl=cell(1,bln);%�洢��С�ֿ����
for i=1:bln
    D2bl{1,i}=inputA(bl*(i-1)+1:bl*i,bl*(i-1)+1:bl*i);%����ֵ
end
D2blinv=cell(1,bln);%�洢��С�ֿ����������
for i=1:bln
    D2blinv{1,i}=D2bl{1,i}^(-1);%bl�׾�������
end

%�ڶ������
D3=cell(1,2);
for i=1:2
    D3{1,i}=inputA((i-1)*dimD1bl+1:i*dimD1bl,(i-1)*dimD1bl+1:i*dimD1bl);
end

D3bl=cell(1,2);
for i=1:2
    D3bl{1,i}=blkdiag(D2bl{1,(i-1)*bln/2+1:i*bln/2});
end

D3blinv=cell(1,2);
for i=1:2
    D3blinv{1,i}=blkdiag(D2blinv{1,(i-1)*bln/2+1:i*bln/2});
end

D3inv=cell(1,2);
for i=1:2
    D3inv{1,i}=zeros(dimD1bl);
end
for i=1:2
    for ia1=0:ka2-1
        D3inv{1,i}=D3inv{1,i}+(-D3blinv{1,i}*(D3{1,i}-D3bl{1,i}))^(ia1)*D3blinv{1,i};
    end
end

%��һ�����
D1=inputA;
D1bl=blkdiag(D3{1,1:2});
D1blinv=blkdiag(D3inv{1,1:2});
D1inv=zeros(dimA);
for ia1=0:ka1-1
    D1inv=D1inv+(-D1blinv*(D1-D1bl))^(ia1)*D1blinv;
end

outputA=D1inv;
 