function [Gend] = makeSSCV(Gc,G0,sdata)
    flag1=1;
    k=1;
    score=-9999999;
    
    node_size=max(sdata);
    
    while flag1
        [Gs, ~, ~] = my_mk_nbrs_of_dag(G0,Gc);
        bdeuScore=score_dags(sdata',node_size,Gs);
        [tmp,i]=max(bdeuScore);
        if tmp<=score
            k=k+1;
        else
            score=tmp;
            G0=Gs{i};
        end
        if k>1
            break;
        end
    end
    Gend=G0;           
end