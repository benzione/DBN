function [Gend, seps, Nci] = learn_struct_pdag_rai_shd(Gstart,dag,cv,ex_nodes,...
    s_nodes,seps_start,n,cond_indep,sdata,varargin)
global data
global NCI
if strcmp(cond_indep,'dsep')
    disp('NOTE!!! Using ideal d-sep function');
end
% global MI % NxN matrix of mutual information values


[Nc,nn] = size(sdata);
NCI=zeros(1,nn-1);
probArr=zeros(Nc);

% MI = zeros(nn,nn);
% for k = 1:(nn-1)
%     for kk = (k+1):nn
%         MI([k+(kk-1)*nn, kk+(k-1)*nn]) = mutualC_e(k,kk,[],sdata);
%     end
% end
cvProb=rand(Nc,cv);
shd=0;
for i=1:cv
    tmp= cvProb(:,i)<=0.7;
    data = sdata(tmp,:);
    disp(i)
    [Gend, seps, ~] = learn_struct_rai(Gstart,ex_nodes,s_nodes,[],seps_start,probArr,n...
        ,cond_indep,varargin{:});
    [tmp,~,~,~,~,~]=SHD_parts_asaf(Gend,dag);
    shd=shd+tmp;

end

Gend= shd/cv;
Nci = shd;

clear global data
clear global NCI
clear global MI