function CI = MI_LOG2(Xi,Xj,C,fulldata)
% BASED on MUTUALC_E function. main difference- here we calculated MI based
% on log2 and not log natural (Michal Caspi)
% MUTUALC_E calculates the conditional mutual information
% between two variables given a set of variables
%
% CI = mutualC_e(Xi,Xj,C,fulldata)
% mutual information between Xi and Xj given set of variables C
%
% Xi, Xj - column number in 'fulldata'
% C - set of column numbers corresponding to the condition set of variables
% fulldata(j,i)  - variable i, case j.
%
% IMPORTANT:    Values must be discreate and 1-based
%
%
% Example:
% CI = mutualC_e(1, 2, [3 4 5], fulldata)
% conditional mutual information between variables 1 and 2 given variables 3, 4 and 5
%
% Written by Raanan Yehezkel
% September 2002
%
% Requires the function 'compute_counts' from BNT

data=fulldata(:,[Xi,Xj,C])';
dsize=size(data);
[nEvents,nNodes]=size(fulldata);

if (prod(max(data')) > 8*1024*1024)
    CI = 0;
else

    counts=compute_counts(data,max(data'));

    [isize,jsize,csize]=size(counts);
    d_c=reshape(counts,isize,jsize,csize);
    c=0;
    I=0;
    for k=1:csize
        d_c_p=d_c(:,:,k);
        cnum=sum(sum(d_c_p));
        if cnum>0
            mt=d_c_p./cnum;
            for ki=1:isize
                for kj=1:jsize
                    if d_c_p(ki,kj)>0
                        c=c+1;
                        lg=log2(mt(ki,kj)/((sum(d_c_p(:,kj))/cnum).*(sum(d_c_p(ki,:))/cnum)));
                        I=I+(d_c_p(ki,kj)/nEvents).*lg;
                        %                     fprintf('p = %.4f;\tlg = %.4f\n',(d_c_p(ki,kj)/nEvents),lg)
                    end
                end
            end
        end
    end

    % I = 0.5 * (I/joint_entropy(Xi,Xi,C,fulldata) + I/joint_entropy(Xj,Xj,C,fulldata));
    % CI=I/joint_entropy(Xi,Xj,C,fulldata);
    % I=I/log(c^(1/size(data,1)));

    % % % % % % % % % % % % % % % % % % % % % % % % % % % I=I/log(c);

    CI=I;% CI=I/joint_entrophy(Xi,Xj,C,fulldata);
    % CI=I/joint_entrophy(Xi,Xi,C,fulldata);

end