 function NCM = cal_NCM(inputA,K,itcounts)

 %Ԥ�������
 dimA=size(inputA);
 M=dimA(1,1);%���������Ľ���
 O=M/K;%�Ӿ���Ľ���
 submatrixarr=cell(1,K);
 NCM=0;
 
 %���Ӿ���ֵ
 for i=1:K
     submatrixarr{1,i}=inputA((i-1)*O+1:i*O,(i-1)*O+1:i*O);
 end
 mD=blkdiag(submatrixarr{1,1:K});
 mDinv=mD^(-1);
 mE=inputA-mD;
 
 %����ÿ�ε����ĳ˷�����
 tempout=mDinv;
 temp=-mDinv*mE;
 NCM=cal_subNCM(mDinv,mE,M);
 for i=1:itcounts-1
     NCM=NCM+cal_subNCM(tempout,temp,M);
%      cal_subNCM(tempout,temp,M)
     tempout=tempout*temp;
 end
 