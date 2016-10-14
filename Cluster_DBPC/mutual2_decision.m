function [CI,I]=mutual2_decision(Xi,Xj,C,fulldata,threshold)
% MUTUALC_F_E conditional mutual information CI-test for discrete nodes
%
%   [CI,I] = mutualC_f_e(Xi,Xj,C,fulldata,th)
%   CI = mutualC_f_e(Xi,Xj,C,fulldata,th)
%
%   CI - CI test result
%   I - conditional mutual information value
%   fulldata - database:  fulldata(i,j) - instance i, variable j.
%   th - threshold for mutual information
%
% Written by Raanan Yehezkel
% September 2002
% Updated by Michal Caspi (july 2011)
%
% Requires the function 'compute_counts' from BNT


I=MI_LOG2(Xi,Xj,C,fulldata);


if I<threshold
    CI=1;
else
    CI=0;
end