function [Gend, seps, Nci] = learn_struct_pdag_rai_cv(Gstart,cv,ex_nodes,...
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
bn=cell(cv,2);
% probCV=zeros(nn,nn,cv);
G=zeros(nn);
for i=1:cv
    tmp= cvProb(:,i)<=0.7;
    data = sdata(tmp,:);
    disp(i)
    [Gend, seps, ~] = learn_struct_rai(Gstart,ex_nodes,s_nodes,[],seps_start,probArr,n...
        ,cond_indep,varargin{:});
    bn{i,1}=Gend;
    bn{i,2}=seps;
%     probCV(:,:,i)=probArrE;
    G=G+Gend;
end
G=G/cv;
over5=G>=0.5;
less5=(G>0 & G<0.5);

a=(over5==1 & over5'==0 & less5'==0);
b=(over5==1 & over5'==1);
c=(over5==1 & less5'==1);
d=(less5==1 & less5'==1);
e=(less5==1 & less5'==0 & over5'==0);

G1=a+0;

disp('a');

Gend=makeSSCV([],G1,sdata);

disp('b');

G2=b+0;

Gend=makeSSCV(G2,Gend,sdata);

disp('c');

G2=c+0;

Gend=makeSSCV(G2,Gend,sdata);

disp('d');

G2=d+0;

Gend=makeSSCV(G2,Gend,sdata);

disp('e');

G2=e+e'+0;

Gend=makeSSCV1(G2,Gend,sdata);

Nci = NCI;

clear global data
clear global NCI
clear global MI