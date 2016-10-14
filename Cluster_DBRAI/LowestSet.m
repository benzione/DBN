function LowestC = LowestSet(Ga, s_nodes)
% LowestSet(Ga, s_nodes)
% findes the lowest topological order nodes in pattern Ga.
% s_nodes are the nodes of interest

if nargin<2
    s_nodes = 1:size(Ga,1);
end

Da = (Ga & (~Ga')); % only directed edges
Ua = (Ga & (Ga')); % only un-directed edges

[P,junk] = find(Da); % find nodes that are parents of someone
C = setdiff(s_nodes,P); % nodes that are not parents of anyone

% C still contains nodes that are adjacent to a parent node making it have
% equal topological order of the parent and thus not a descendant. For
% example: C--P->D

% remove from C nodes that are reachable in Ua and are parents of someone
RG = setdiag(reachability_graph(double(Ua)),0); % reachability in Ua
LowestC = [];
for k = C
    S = find(RG(k,:)); % nodes that have an undirected path to node k
    if isempty(intersect(S,P)) % a parent is not reachable via undirected
        LowestC = [LowestC, k];
    end
end