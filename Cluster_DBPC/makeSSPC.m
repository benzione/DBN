function G=makeSSPC(Gstart,data)
    
    node_size=max(data);
    Gtest=Gstart;
%     R=length(Gstart);
    
    scorebest=score_dags(data',node_size,{Gtest});
    k=1;
    
    [X,Y]=find(Gtest);
    for j=1:length(X)
        x=X(j);
        y=Y(j);
        flag1=1;
        Gtest(x,y)=0;
        if acyclic(Gtest, 1)
            scoretmp=score_dags(data',node_size,{Gtest});
            if scoretmp<scorebest
                Gtest(x,y)=1;
                k=k+1;
            else
                scorebest=scoretmp;
                k=1;
                flag1=0;
            end
        else
            Gtest(x,y)=1;
        end

        if ~flag1
            Gtest(y,x)=1;
        else
            Gtest(x,y)=0;
            Gtest(y,x)=1;
        end

        if acyclic(Gtest, 1)
            scoretmp=score_dags(data',node_size,{Gtest});
            if scoretmp<scorebest
                k=k+1;
                if ~flag1
                    Gtest(y,x)=0;
                else
                    Gtest(x,y)=1;
                    Gtest(y,x)=0;
                end
            else
                scorebest=scoretmp;
                k=1;
            end
        else
            if ~flag1
                Gtest(y,x)=0;
            else
                Gtest(x,y)=1;
                Gtest(y,x)=0;
            end
        end

        tmp1=Gtest(x,y);
        tmp2=Gtest(y,x);
        Gtest(x,y)=0;
        Gtest(y,x)=0;
        if acyclic(Gtest, 1)
            scoretmp=score_dags(data',node_size,{Gtest});
            if scoretmp<scorebest
                k=k+1;
                Gtest(x,y)=tmp1;
                Gtest(y,x)=tmp2;
            else
                scorebest=scoretmp;
                k=1;
            end
        else
            Gtest(x,y)=tmp1;
            Gtest(y,x)=tmp2;
        end
    end 
    G=Gtest;
    
end