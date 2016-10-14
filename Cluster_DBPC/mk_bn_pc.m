function [ Gend, t ] = mk_bn_pc( data,th,varargin )
ts=tic;
[~,N]=size(data);

gstart2=setdiag(ones(N), 0); 


[Gend,~]= learn_struct_pdag_pc (gstart2,'mutualC_f_e',N,N,data,th,varargin);

Gend=abs(Gend);

t=toc(ts);
end





