function gr=unconnected_ancestors(G,a_nodes)

gr={[]};
k=1;

L=a_nodes;

R=double(reachability_graph(double(G | G')));

while ~isempty(L)
    node=L(1);
    ns=find(R(node,:));
    group=union(ns,node);
    gr{k}=group;
    k=k+1;
    L=setdiff(L,group);
end