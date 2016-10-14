function [CI,I]=mutualC_f_e(Xi,Xj,C,fulldata,varargin)
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
%
% Requires the function 'compute_counts' from BNT

I=mutualC_e(Xi,Xj,C,fulldata);

%I=I/(0.5*(mutualC_(Xi,Xi,C,fulldata)+mutualC_(Xj,Xj,C,fulldata)));
% I=I/joint_entrophy(Xi,Xj,C,fulldata);

%th=1.5e-4;

%th=15e-10;
%th=1.7e-4;  % Best threshold
%th=1e-4;

if length(varargin)==0
    % th=0.9975; % for 5 node binary net
    % th=0.99145; % for Cito database
    % th=0.9865; % for Cito database
    %th=0.98; % for Cito database
    th=1-0.999; % for nursery
else
    th=varargin{1};
end

if I<th
    CI=1;
else
    CI=0;
end