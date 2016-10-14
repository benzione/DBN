function [ Gend, t ] = mk_dbn_pc( data,th,varargin )
ts=tic;
[~,N]=size(data);
C=N/2;
% training=zeros(R-1,N);
% training(:,1:C)=data(1:end-1,:);
% training(:,C+1:N)=data(2:end,:);
% ns=max(training);

training=data+1;

gstart2=setdiag(ones(N), 0); 
gstart2(1:C,1:C)=0;

[Gend,~]= learn_struct_pdag_pc (gstart2,'mutualC_f_e',N,N,training,th,varargin);

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





