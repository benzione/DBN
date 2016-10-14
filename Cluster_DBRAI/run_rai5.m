addpath(genpath('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\bnt'));
clear all;
clear clc;

ss=[500,1000,5000];
strnodes={'Child','Insurance','Alarm1'};
% ss=5000;
% strnodes={'Alarm1'};
summary=cell(9,5);
time=cell(9,5);
shd=zeros(9,1);

% alpha=[0.01,0.05,0.1];
% for w=alpha
    w=0.05;
    k=1;
    for j=strnodes
        str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Source\DBs\'...
            ,j{1},'\',j{1},'_graph.txt');
        dag=txt2mat(str,0);
        dag=dag_to_cpdag(dag);
        for i=ss
            for q=1:5
                str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Source\DBs\'...
                    ,j{1},'\',j{1},'_s',num2str(i),'_v',num2str(q),'.txt');
                sdata=txt2mat(str,0);
                disp([w*100,k,q]);
                training=sdata+1;
                [~,~, x,t]=mk_bn_rai_cv(training,w,10);
%                 [x,~, ~,t]=mk_bn_rai(training,w);
%                 [x,~,~,~] = mk_bn_rai_shd(training,dag,w,10);
                summary{k,q}=x;
%                 time{k,q}=t;
%                 shd(k)=shd(k)+x;

            end
            str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Outputs\Synthetic_Benc\summary_RAI_michal_G_LSO_dags'...
                ,num2str(w*100),'.mat');
            save(str,'summary');
            k=k+1;
        end
    end
    shd=shd/5;
%     str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Outputs\Synthetic_Benc\summary_RAI_michal_shd_dags'...
%         ,num2str(w*100),'.mat');
%     save(str,'shd');
% end
rmpath(genpath('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\bnt'));