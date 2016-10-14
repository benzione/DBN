function [ Gend, seps, Nci,t] = mk_bn_rai_cv(data,th,cv)
ts=tic;
[~,N]=size(data);
Gend=setdiag(ones(N), 0);


[Gend, seps, Nci]=learn_struct_pdag_rai_cv(Gend,cv,...
    [],1:N,cell(N),...
    0,'',data,th);

t=toc(ts);
end


