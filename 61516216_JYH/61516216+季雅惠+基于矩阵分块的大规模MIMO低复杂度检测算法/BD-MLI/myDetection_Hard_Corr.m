% hard detection, BER

clc;
clear all;close all;

% ����ѭ������
targetErrors = 500;
maxNumTransmissions = 5e7;

% ���Ʒ�ʽ
M = 16;
k = log2(M);

% ��������
nRx = 256;%��վ������
nTx = 32;%�û���
bl=1;%ÿ���û���������
zeta_r=0.5;%��վ���������
zeta_t=0;%�û������������
BERNum = 7;%�����㷨��
SNRdB = 4:2:14;%����ȷ�Χ
frameLength = 2^11; %�������

% ����ȶ���
Es = 1;
EsN0dB = SNRdB - 10*log10(nTx);
% EsN0dB = SNRdB - 10*log10(nTx);
%Eb = Es/k;
%EbN0dB = EsN0dB - 10*log10(k);
%EbN0 = 10.^(EbN0dB/10);
EsN0 = 10.^(EsN0dB/10);
N0 = Es./EsN0;

% ���;������
scaling = 1; % ����ͼ������һ��
% frameLength = 2^6;

% ��ʼ��
% BERNum = 3;%�����㷨��
[hErrorCalc, BERVec] =  Generator_BERVec(SNRdB, BERNum);
cSHat = cell(BERNum, 1);
demodData = cell(BERNum, 1);
decLLRMat = cell(BERNum, 1);
decBit = cell(BERNum, 1);
modData = zeros(frameLength, nTx);
cLegend = cell(BERNum, 1);
for n=1:length(SNRdB)
    for i = 1:BERNum
        reset(hErrorCalc{i});
    end
%     while (BERVec{7}(2,n) < targetErrors) && (BERVec{7}(3,n) < maxNumTransmissions) 
        data = randi([0 1], frameLength*nTx*k, 1);
        dataMat = reshape(data, frameLength*k, nTx);
        % ��ÿ�����������롢����
        for istream = 1:nTx 
            modData(:,istream) = Mod_QAM(dataMat(:,istream),M,scaling);
        end          
        frmSymbol = modData.';
        ch = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Es/No)','EsNo',EsN0dB(n));
        % ����frameLength�η�������
        for itx = 1:frameLength
            TxSymbol = frmSymbol(:,itx);
            cH =  newchennel(nRx,nTx,zeta_r,0,zeta_t,bl);
            cB = cH*TxSymbol;
            cY = step(ch,cB);
            cG = cH'*cH;
            cW = cG + eye(nTx)*N0(n);
            cWinv = cW^(-1);
            cYBar = cH'*cY;
            cD = diag(diag(cW));
            cDinv = cD^(-1);
    

            cWinvNeum1 = Method_TMA(cW,15);
            cWinvNeum2 = Method_TMA(cW,10);
            cWinvNeum3 = Method_TLI(cW,7,9,2);
            cWinvNeum4 = Method_TLI(cW,6,9,2);
            cWinvNeum5 = Method_BD_MLI(cW,7,9,bl);
            cWinvNeum6 = Method_BD_MLI(cW,6,9,bl);
    
            cSHat{1} = cWinv*cYBar;
            cSHat{2} = cWinvNeum1*cYBar;
            cSHat{3} = cWinvNeum2*cYBar;
            cSHat{4} = cWinvNeum3*cYBar;
            cSHat{5} = cWinvNeum4*cYBar;
            cSHat{6} = cWinvNeum5*cYBar;
            cSHat{7} = cWinvNeum6*cYBar;

            matE1 = cWinv*cG;
            [mu1,rho1] = Calc_SINR_Appr(matE1,ones(nTx,1));

            % ����LLR
            for i = 1:BERNum
                demodData{i} = Calc_LLR_Appr(rho1,cSHat{i},M,1);
                decLLRMat{i}(k*(itx-1)+1:k*itx,:) = demodData{i};
            end
        end
        for i = 1:BERNum
            % Ӳ�о�
            decBit{i}=Calc_Hard_Decision(decLLRMat{i});
            % �ۻ����������������������
            BERVec{i}(:,n) = step(hErrorCalc{i}, dataMat(:), decBit{i}(:));
        end
%     end   
    disp(['SNR=',num2str(SNRdB(n))])
end

%%
%dataName = ['data\Hard_BER_Corr_',num2str(nRx),'x',num2str(nTx)];
%save(dataName,'M','BERNum','BERVec','SNRdB','itStart')
%%
figure(2)
semiplot = semilogy(...
SNRdB,BERVec{1}(1,:),'-',...
SNRdB,BERVec{2}(1,:),'.-',...
SNRdB,BERVec{3}(1,:),'--',...
SNRdB,BERVec{4}(1,:),'.-',...
SNRdB,BERVec{5}(1,:),'--',...
SNRdB,BERVec{6}(1,:),'.-',...
SNRdB,BERVec{7}(1,:),'--',...
'LineWidth',2, 'MarkerSize',18);
set(semiplot(1),'Color',[0 0 0]);
set(semiplot(2),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
set(semiplot(3),'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
set(semiplot(4),'Color',[0.850980401039124,0.325490206480026,0.0980392172932625]);
set(semiplot(5),'Color',[0.850980401039124,0.325490206480026,0.0980392172932625]);
set(semiplot(6),'Color',[61, 89, 171]/256);
set(semiplot(7),'Color',[61, 89, 171]/256);
grid on;
strLegend = {'$MMSE$',...
'$TMA,k=7$',...
'$TMA,k=6$',...
'$BM,k_F=6,k_S=7$',...
'$BM,k_F=5,k_S=7$',...
'$BD-MLI,k_F=6,k_N=7$',...
'$BD-MLI,k_F=5,k_N=7$'};
legend_handle = legend(strLegend,3);
set(legend_handle,'Interpreter','latex')
xlabel ('SNR [dB]'); ylabel ('BER');
