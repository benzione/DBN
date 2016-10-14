function [Gend] = makeSSCV1(Gc,G0,sdata)
    flag1=1;
    k=1;
    disp(k);
    score=-9999999;
    
    node_size=max(sdata);
    scoreArr=zeros(10,1);
    dags=cell(10,1);
    while flag1
        [Gs, ~, ~] = my_mk_nbrs_of_dag(G0,Gc);
        bdeuScore=score_dags(sdata',node_size,Gs);
        [tmp,i]=sort(bdeuScore,'descend');
        if tmp(1)<=score
            scoreArr(k)=score;
            dags{k}=G0;
            score=tmp(3);
            G0=Gs{i(3)};
            k=k+1; 
            disp(k);
        else
            score=tmp(1);
            G0=Gs{i(1)};
        end
        if k>10
            break;
        end
    end
    [~,i]=max(scoreArr);
    
    Gend=dags{i};           
end