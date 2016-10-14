function [ Gend, seps, Nci,t] = mk_bn_rai(data,th,varargin)
ts=tic;
[~,N]=size(data);
Gend=setdiag(ones(N), 0); 

[Gend, seps, Nci]=learn_struct_pdag_rai(Gend,...
    [],1:N,cell(N),zeros(N),...
    0,'',data,th,varargin);

t=toc(ts);
end


