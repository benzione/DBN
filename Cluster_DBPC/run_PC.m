addpath(genpath('C:\Users\Eyal\Dropbox\Research Eyal\RAI\RAI\bnt'));
% addpath(genpath('/fastspace/users/benzione/bnt'));
% addpath(genpath('/fastspace/users/benzione/PC_BN'));
clear all;
clear clc;

% ss=[500,1000,5000];
% strnodes={'Child','Insurance','Alarm1'};

ss=500;
strnodes={'Alarm1'};
SHD=zeros(4,8);
dags=cell(4,8);
bdeuArr=zeros(4,8);


% alpha=[0.01,0.05,0.1];
% for w=alpha
    w=0.05;
    k=1;
    for j=strnodes
% %         str=strcat('C:\Users\Eyal\Dropbox\Research Eyal\RAI\RAI\Source\DBs\'...
% %             ,j{1},'\',j{1},'_graph.txt');
        str=strcat('/fastspace/users/benzione/DBs/'...
            ,j{1},'/',j{1},'_graph.txt');
        dag=txt2mat(str,0);
        dag=dag_to_cpdag(dag);
        for i=ss
            for q=1:5
                str=strcat('C:\Users\Eyal\Dropbox\Research Eyal\RAI\RAI\Source\DBs\'...
                    ,j{1},'\',j{1},'_s',num2str(i),'_v',num2str(q),'.txt');
%                 str=strcat('/fastspace/users/benzione/DBs/'...
%                     ,j{1},'/',j{1},'_s',num2str(i),'_v',num2str(q),'.txt');
                sdata=txt2mat(str,0);
                [~,C]=size(sdata);
                training=sdata+1;
                SHD=zeros(5,8);
                dags=cell(5,8);
                bdeuArr=zeros(5,8);
                k=1;
                for w=0.0015:0.0005:0.005
                    disp([w*10000,k,q]);
                    [x,~]=learn_struct_pdag_pc ('mutualC_f_e',C,C,training,w);
                    [shd,~,~,~,~,~]=SHD_parts_asaf(x, dag);
                    SHD(q,k)=shd;
                    dags{q,k}=x;
                    k=k+1;
                end
                node_size=max(training);
                bdeuScore=score_dags(training',node_size,dags{q,:});
                bdeuArr(q,:)=bdeuScore;
            end
        end
    end
% end
% str=strcat('C:\Users\Eyal\Dropbox\Research Eyal\RAI\RAI\Outputs\SHD_PC_g2_'...
%                 ,num2str(w*100),'.mat');
str=strcat('/fastspace/users/benzione/Outputs/summary_PC.mat');
save(str,'dags','SHD','bdeuArr');
rmpath(genpath('/fastspace/users/benzione/bnt'));
rmpath(genpath('/fastspace/users/benzione/PC_BN'));
% rmpath(genpath('C:\Users\Eyal\Dropbox\Research Eyal\RAI\RAI\bnt'));