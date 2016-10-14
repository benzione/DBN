function [ Gend, seps, Nci,t] = mk_dbn_rai(data,th,varargin)
ts=tic;
[~,N]=size(data);
C=N/2;
% training=zeros(R-1,N);
% training(:,1:C)=data(1:end-1,:);
% training(:,C+1:N)=data(2:end,:);
% ns=max(training);
data=data+1;
Gend=setdiag(ones(N), 0); 
Gend(1:N,1:C)=0;

[Gend, seps, Nci]=learn_struct_pdag_rai(Gend,...
    1:C,1+C:N,[],...
    0,'',data,th,varargin);

tmp=zeros(N);
tmp(1+C:N,1:C)=Gend(1+C:N,1:C);
tmp=tmp';
Gend=tmp | Gend;
Gend(1+C:N,1:C)=0;
Gend(1:C,1:C)=Gend(1+C:N,1+C:N);
Gend=+Gend;
t=toc(ts);
end


