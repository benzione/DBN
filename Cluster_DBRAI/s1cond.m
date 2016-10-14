function [s1_value,df]=s1cond(num_x,num_y,num_s, fulldata,alpha)
%full data- data matrix. num_x- number of col1, num_y-num of col2. 
%num_s- number of columns in S.
%between these variables s1 will be calculated
% written by Michal Caspi, 25/3/2011

n=size(fulldata);%n is a vector: n(1,1)=num of records, n(1,2)=num of attributes
n=n(1,1);%num of records
const=2*n; %%s1 const

x=fulldata(:,num_x);
card_x=length(unique(x)); %% number of unique values of x, |x|

y=fulldata(:,num_y);
card_y=length(unique(y));%% number of unique values of y, |y|

s=fulldata(:,num_s);
k=size(s);
k=k(:,2); % number of variables in S

card_z=1;
for i=1:k
    card_z=card_z*length(unique(s(:,i)));    
end

df=(card_x-1)*(card_y-1)*card_z;

%% please pay attention to a correction I made- if df=0, variabales
%% independent
if df==0
    s1_value=9999; % so that the variables will be regarded independent. Edna and Parmet recommandation
else

    s1_value=chi2inv(1-alpha,df)/const;
end
end