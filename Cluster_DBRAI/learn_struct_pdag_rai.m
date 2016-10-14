function [Gend, seps, Nci] = learn_struct_pdag_rai(Gstart,ex_nodes,...
    s_nodes,seps_start,probArr,n,cond_indep,sdata,varargin)
global data
global NCI
if strcmp(cond_indep,'dsep')
    disp('NOTE!!! Using ideal d-sep function');
end
% global MI % NxN matrix of mutual information values

data = sdata;
[Nc,nn] = size(sdata);
NCI=zeros(1,nn-1);

[Gend, seps,probArr] = learn_struct_rai(Gstart,ex_nodes,s_nodes,[],seps_start,probArr,n...
    ,cond_indep,varargin{:});


Gend = create_cpdag(Gend,seps,probArr);



Nci = NCI;

clear global data
clear global NCI
clear global MI