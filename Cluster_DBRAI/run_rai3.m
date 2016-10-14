addpath(genpath('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\bnt'));
clear all;
clear clc;

summary=cell(39,1);
time=zeros(39,1);
for i=1:39
    str=strcat('C:\Users\benzione\Dropbox\Research Eyal\LMP\File\LMP Database\User_',...
        num2str(i),'_corr_time.mat');
    load(str);
    disp(i);
    [x, ~, ~, t]=mk_dbn_rai_corr(training,0.05);
    summary{i}=x;
    time(i)=t;
end
str=strcat('C:\Users\benzione\Dropbox\Research Eyal\LMP\File\LMP RAI\result_lmp_RAI.mat');
save(str,'summary','time');
rmpath(genpath('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\bnt'));
fclose('all');