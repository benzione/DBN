function [Gend,seps,probArr] = remove_ex_effect(Gstart,ex_nodes,s_nodes,class_node,seps_start,probArr,n,cond_indep,data,varargin)

seps  = seps_start;
Gend = Gstart;

Gtmp = zeros(size(Gend));
Gtmp(ex_nodes,s_nodes) = 1;

[P,C] = find(Gtmp & Gend); % edges to be tested

% remove edges from class node from being tested
% Class_id = find(ismember(P,class_node));
% Other_id = setdiff([1:length(P)],Class_id);
% P = P(Other_id);
% C = C(Other_id);


% for k = 1:length(P)
%     pa = setdiff(union(find(Gend(:,P(k))),find(Gend(:,C(k)))),[P(k),C(k)]);
%     S = subsets(pa,n,n);
%     for si = 1:length(S)
%         if feval(cond_indep,P(k),C(k),S{si},data,th)
%             seps{P(k),C(k)} = S{si};
%             seps{C(k),P(k)} = S{si};
%             Gend(P(k),C(k)) = 0;
%             lnk = 0;
%             break
%         end
%     end
% end
% [Gend,seps] = test_edges_score(P,C,Gend,ex_nodes,s_nodes,seps,n,cond_indep,data,varargin{:});
[Gend,seps,probArr] = test_edges_S(P,C,Gend,ex_nodes,s_nodes,class_node,seps,probArr,n,cond_indep,data,varargin{:});
% [Gend,seps] = test_edges_AT(P,C,Gend,ex_nodes,s_nodes,seps,n,cond_indep,data,varargin{:});

