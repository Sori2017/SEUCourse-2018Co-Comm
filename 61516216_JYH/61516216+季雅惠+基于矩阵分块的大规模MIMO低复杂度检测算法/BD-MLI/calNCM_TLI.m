 function NCM = calNCM_TLI(inputA,k1,k2,K)

% clc;
% clear all;close all;
% ��������
% nRx = 256;%��վ������
% nTx = 64;%�û���
% bl=1;%ÿ���û���������
% itcounts=4;%��������
% % ����ȶ���
% Es = 1;
% % SNRdB = 4:2:16;
% SNRdB = 10;
% EsN0dB = SNRdB - 10*log10(nTx);
% % EsN0dB = SNRdB - 10*log10(nTx);
% %Eb = Es/k;
% %EbN0dB = EsN0dB - 10*log10(k);
% %EbN0 = 10.^(EbN0dB/10);
% EsN0 = 10.^(EsN0dB/10);
% N0 = Es./EsN0;
% n=1;
% cH =  newchennel(nRx,nTx,0.2,0,0,bl);
% cG = cH'*cH;
% cW = cG + eye(nTx)*N0(n);
% inputA=cW;
%  k1=8;
%  k2=8;
%  K=2;
 
 NCM=0;
%˫�����
dimA=size(inputA);
dimD1bl=dimA(1,1)/K;%��һ������Ӿ���ά��

D3=cell(1,K);
for i=1:K
    D3{1,i}=inputA((i-1)*dimD1bl+1:i*dimD1bl,(i-1)*dimD1bl+1:i*dimD1bl);
end

D3inv=cell(1,K);
for i=1:K
    D3inv{1,i}=zeros(dimD1bl);
end
%�ڶ������
for i=1:K
    D3inv{1,i}=Method_Neumann(D3{1,i},k2);
    temp=size(D3{1,i});
    NCM=NCM+cal_NCM(D3{1,i},temp(1,1),k2);
end
D1=inputA;
D1bl=blkdiag(D3{1,1:K});
D1blinv=blkdiag(D3inv{1,1:K});
D1inv=zeros(dimA);
%��һ�����
for ia1=0:k1-1
    D1inv=D1inv+(-D1blinv*(D1-D1bl))^(ia1)*D1blinv;
end
NCM=NCM+cal_NCM(inputA,K,k1);