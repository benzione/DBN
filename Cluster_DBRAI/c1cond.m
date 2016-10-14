function c1_value=c1cond(num_x,num_y,num_s, fulldata)

%full data- data matrix. num_x- number of col1, num_y-num of col2.
%num_s- number of columns in S.
%between these variables c1 will be calculated
%c1=(|x|-1)(|y|-1)*|Z1|*.....*|ZK| 
%(K- number of variables in the condition set S)
% written by Michal Caspi, 19/7/2011

n=size(fulldata);%n is a vector: n(1,1)=num of records, n(1,2)=num of attributes
n=n(1,1);%num of records
const=2*n*(log(2)); %%c1 const

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

c1_value=(card_x-1)*(card_y-1)*card_z/const;

end