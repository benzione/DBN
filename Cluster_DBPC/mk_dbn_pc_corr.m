function [ Gend, t ] = mk_dbn_pc_corr( data,th,varargin )
ts=tic;
N=size(data,2);
C=N/2;
gstart2=setdiag(ones(N), 0); 
gstart2(1:C,1:C)=0;

[Gend,~]= learn_struct_pdag_pc (gstart2,'mutualC_f_e',N,N,data,th,varargin);

Gend=abs(Gend);
tmp=zeros(N);
tmp(1+C:N,1:C)=Gend(1+C:N,1:C);
tmp=tmp';
Gend=tmp | Gend;
Gend(1+C:N,1:C)=0;
Gend(1:C,1:C)=Gend(1+C:N,1+C:N);
Gend=+Gend;

t=toc(ts);
end





