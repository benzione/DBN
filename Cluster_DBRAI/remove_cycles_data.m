function acycdag = remove_cycles_data(pdag,data)
% acycdag = remove_cycles_data(pdag,data)
%     pdag - pdag with cycles
%     data(instance, node)

acycdag = pdag;

ddag = double((pdag == 1) & (pdag' == 0)); % graph containing only the directed edges


while ~acyclic(ddag)
    cyc=find(diag(reachability_graph(ddag))); % nodes participating in directed cycles
    cycsize = length(cyc); % number of nodes
    
    MI = [];
    MIid = 1;
    for k = 1:cycsize
        node = cyc(k);
        pa = find(ddag(:,node));
        cycpa = intersect(pa, cyc); % parent nodes that are part of the cycles
        for kk = 1:length(cycpa)
            extpa = setdiff(pa, cycpa(kk)); % parents that are external to the cycle
            MI(MIid,:) = [cycpa(kk), node, mutualC_e(cycpa(kk), node, extpa', data)];
            MIid = MIid + 1;
        end
    end
    minid = find(MI(:,3) == min(MI(:,3)), 1, 'first');
    ddag(MI(minid, 1), MI(minid, 2)) = 0;

    acycdag(MI(minid, 1), MI(minid, 2)) = 0;
        
end