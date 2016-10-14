function [ pdag ] = findVstructure(G, sep, probArr )

% pdag = G;

% Each edge in pdag and G, G(x,y), should have a value ONLY one of the
% following:
%   directed edge:  (-1, 0)
%   undirected edge:( 1, 1)
%   no edge:        ( 0, 0)
vStructure=cell(1);
flag=0;
[X, Y] = find(G==1);
% We want to generate all unique triples x,y,z
% This code generates x,y,z and z,y,x.
for i=1:length(X)
  x = X(i);
  y = Y(i);
  Z = find(G(:,y)==1|G(:,y)==-1);
%   Z = find(G(:,y)==1);
  Z = mysetdiff(Z, x);
  % x--y--z
  for z=Z(:)'
    if (G(x,z)==0) && (G(z,x)==0)... % x and z are disconnected
        && ~ismember(y, sep{x,z}) && ~ismember(y, sep{z,x})

        vS.pa1=x;
        vS.pa2=z;
        vS.col=y;
        vS.prob=probArr(z,x);

        flag1=0;
        R=length(vStructure);
        for j=1:R
            if flag
                if vStructure{1,j}.prob<vS.prob 
                    if j==1
                        tmp{1,1}=vS;
                        vStructure=[tmp,vStructure];
                        flag1=1;
                        break;
                    else if j==R
                            tmp{1,1}=vS;
                            vStructure=[vStructure,tmp];
                            flag1=1;
                            break;
                        else
                            tmp{1,1}=vS;
                            vStructure=[vStructure(1,1:j-1),tmp,vStructure(1,j:end)];
                            flag1=1;
                            break;
                        end
                    end
                end
            else
                vStructure{1,1}=vS;
                flag=1;
                flag1=1;
                break;
            end
        end
        if ~flag1
            tmp{1,1}=vS;
            vStructure=[vStructure,tmp];
        end
    end
  end
end

if flag
    for i=1:length(vStructure)
        x=vStructure{1,i}.pa1;
        z=vStructure{1,i}.pa2;
        y=vStructure{1,i}.col;
        if ~(G(y,z)==-1 || G(y,x)==-1)
            G(x,y)=-1;
            G(z,y)=-1;
            G(y,x)=0;
            G(y,z)=0;
        end
    end
end

pdag=G;

end

