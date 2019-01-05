 function outputA = Method_MLI(inputA,k1,k2,K)
% inputA=cW;
% k1=5;
% k2=5;
% bl=4;

 dimA=size(inputA);
 %����Ҫ�ĵ�������m
 if K==2
     m=log2(dimA(1,1));
 else 
     m=log2(dimA(1,1))/2;
 end
%  k=log2(bl);
 itmatrix=cell(1,m+1);%���������
 itmatrixinv=cell(1,m+1);%���������������
 for i=1:m+1 %��i�����
     itmatrix{1,i}=cell(1,K^(i-1)); %��i���������K^(i-1)�����������
     itmatrixinv{1,i}=cell(1,K^(i-1)); 
end
   
 %��itmatrix��ֵ
 for i=1:m+1
     for j=1:K^(i-1)
         itmatrix{1,i}{1,j}=inputA(K^(m-i+1)*(j-1)+1:K^(m-i+1)*j,K^(m-i+1)*(j-1)+1:K^(m-i+1)*j);
     end
 end
 
 %�ȶ�itmatrixinv{1,K^(m+1)}��ֵ�����Ե�m+1�������ֵ
 for j=1:K^(m)
     itmatrixinv{1,m+1}{1,j}=itmatrix{1,m+1}{1,j}^(-1);
 end
 
 %��ǰm�����itmatrixinv��ʼ��
 for i=1:m
     for j=1:K^(i-1)
         itmatrixinv{1,i}{1,j}=zeros(K^(m-i+1));
     end
 end
 
 %ͨ��BDneumann������itmatrixinv
 for i=m:-1:1
     %�ڵ�i�������
     %�����ù��ɾ�����Ҫ����Ϊblkdiag
     itmatrixtemp1=cell(1,K^(i-1));%�洢�ò�����Խ��󣬼�D
     itmatrixtemp2=cell(1,K^(i-1));%�洢�ò�����ǶԽ��󣬼�E
     itmatrixtemp3=cell(1,K^(i-1));%�洢�ò�����Խ����棬��D^(-1)
     for j=1:K^(i-1)
         itmatrixtemp1{1,j}=blkdiag(itmatrix{1,i+1}{1,(j-1)*K+1:j*K});
         itmatrixtemp2{1,j}=itmatrix{1,i}{1,j}-itmatrixtemp1{1,j};
         itmatrixtemp3{1,j}=blkdiag(itmatrixinv{1,i+1}{1,(j-1)*K+1:j*K});
         %������ʼ
         if i==1
             for it=1:k1
                 itmatrixinv{1,i}{1,j}=itmatrixinv{1,i}{1,j}+(-itmatrixtemp3{1,j}*itmatrixtemp2{1,j})^(it-1)*itmatrixtemp3{1,j};
             end
         else
         for it=1:k2
             itmatrixinv{1,i}{1,j}=itmatrixinv{1,i}{1,j}+(-itmatrixtemp3{1,j}*itmatrixtemp2{1,j})^(it-1)*itmatrixtemp3{1,j};
         end
         end
     end
 end
 
 outputA=itmatrixinv{1,1}{1,1};