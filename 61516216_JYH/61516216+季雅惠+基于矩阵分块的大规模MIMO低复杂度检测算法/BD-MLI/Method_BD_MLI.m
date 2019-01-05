 function outputA = Method_BD_MLI(inputA,ka1,ka,bl)
% inputA=cW;
% ka=4;
% ka1=5;
% bl=4;

 dimA=size(inputA);
 m=log2(dimA(1,1));
 k=log2(bl);
 itmatrix=cell(1,m-k+1);%���������
 itmatrixinv=cell(1,m-k+1);%���������������
 for i=1:m-k+1
     itmatrix{1,i}=cell(1,2^(i-1));
     itmatrixinv{1,i}=cell(1,2^(i-1));
end
   
 %��itmatrix��ֵ
 for i=1:m-k+1
     for j=1:2^(i-1)
         itmatrix{1,i}{1,j}=inputA(2^(m-i+1)*(j-1)+1:2^(m-i+1)*j,2^(m-i+1)*(j-1)+1:2^(m-i+1)*j);
     end
 end
 
 %�ȶ�itmatrixinv{1,2^(m-k+1)}��ֵ
 for j=1:2^(m-k)
     itmatrixinv{1,m-k+1}{1,j}=itmatrix{1,m-k+1}{1,j}^(-1);
 end
 
 %��itmatrixinv��ʼ��
 for i=1:m-k
     for j=1:2^(i-1)
         itmatrixinv{1,i}{1,j}=zeros(2^(m-i+1));
     end
 end
 
 %ͨ��BDneumann������itmatrixinv
 for i=m-k:-1:1
     %�ڵ�i�������
     %�����ù��ɾ�����Ҫ����Ϊblkdiag
     itmatrixtemp1=cell(1,2^(i-1));%�洢�ò�����Խ��󣬼�D
     itmatrixtemp2=cell(1,2^(i-1));%�洢�ò�����ǶԽ��󣬼�E
     itmatrixtemp3=cell(1,2^(i-1));%c�洢�ò�����Խ����棬��D^(-1)
     for j=1:2^(i-1)
         itmatrixtemp1{1,j}=blkdiag(itmatrix{1,i+1}{1,(j-1)*2+1:j*2});
         itmatrixtemp2{1,j}=itmatrix{1,i}{1,j}-itmatrixtemp1{1,j};
         itmatrixtemp3{1,j}=blkdiag(itmatrixinv{1,i+1}{1,(j-1)*2+1:j*2});
         %������ʼ
         if i==1
             for it=1:ka1
                 itmatrixinv{1,i}{1,j}=itmatrixinv{1,i}{1,j}+(-itmatrixtemp3{1,j}*itmatrixtemp2{1,j})^(it-1)*itmatrixtemp3{1,j};
             end
         else
         for it=1:ka
             itmatrixinv{1,i}{1,j}=itmatrixinv{1,i}{1,j}+(-itmatrixtemp3{1,j}*itmatrixtemp2{1,j})^(it-1)*itmatrixtemp3{1,j};
         end
         end
     end
 end
 
 outputA=itmatrixinv{1,1}{1,1};
 end