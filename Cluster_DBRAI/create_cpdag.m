function pdag=create_cpdag(G,sep,probArr)

n = size(G,1); % number of nodes

% Selectively copied from BNT, function "learn_struct_pdag_pc"

% Create the minimal pattern,
% i.e., the only directed edges are V structures.

% convert pdag into a matrix having -1 values that indicate arrow head
arrowheads = (G ~= G') & G;
G(arrowheads) = -1;
for i=1:n
    X=find(G(:,i)==-1);
    lengthX=length(X);
    for j=1:lengthX-1
        for k=j+1:lengthX
            x=X(j);
            z=X(k);
            if (G(x,z)==0) && (G(z,x)==0)...
                    && ismember(i, sep{x,z}) && ismember(i, sep{z,x})
                G(x,i) = 1;
                G(i,x) = 1;
                G(z,i) = 1;
                G(i,z) = 1;
            end
        end
    end
end

% pdag=findVstructure(G,sep,probArr);

pdag = G;

% Each edge in pdag and G, G(x,y), should have a value ONLY one of the
% following:
%   directed edge:  (-1, 0)
%   undirected edge:( 1, 1)
%   no edge:        ( 0, 0)

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
%     if (pdag(y,x) == -1), fprintf('%d->%d was reversed\n',y,x);end
%     if (pdag(y,z) == -1), fprintf('%d->%d was reversed\n',y,z);end
      pdag(x,y) = -1; 
      if (pdag(y,x)~=-1), pdag(y,x) = 0; end;
      
      pdag(z,y) = -1;
      if (pdag(y,z)~=-1), pdag(y,z) = 0; end;
    end
  end
end

m = ((pdag==-1) & (pdag'==-1));
pdag(m)=1;

% Convert the minimal pattern to a complete one,
% i.e., every directed edge in P is compelled
% (must be directed in all Markov equivalent models),
% and every undirected edge in P is reversible.
% We use the rules of Pearl (2000) p51 (derived in Meek (1995))

old_pdag = zeros(n);
iter = 0;
while ~isequal(pdag, old_pdag)
  iter = iter + 1;
  old_pdag = pdag;
  % rule 1
  [A,B] = find(pdag==-1); % a -> b
  for i=1:length(A)
    a = A(i); b = B(i);
    C = find((pdag(b,:)==1) & (pdag(a,:)==0) & (pdag(:,a)==0)'); % all nodes adj to b but not a
    if ~isempty(C)
      pdag(b,C) = -1; pdag(C,b) = 0;
      %fprintf('rule 1: a=%d->b=%d and b=%d-c=%d implies %d->%d\n', a, b, b, C, b, C);
    end
  end
  % rule 2
  [A,B] = find(pdag==1); % unoriented a-b edge
  for i=1:length(A)
    a = A(i); b = B(i);
    if any( (pdag(a,:)==-1) & (pdag(:,b)==-1)' );
      pdag(a,b) = -1; pdag(b,a) = 0;
      %fprintf('rule 2: %d -> %d\n', a, b);
    end
  end
  % rule 3
  [A,B] = find(pdag==1); % a-b
  for i=1:length(A)
    a = A(i); b = B(i);
    C = find( (pdag(a,:)==1) & (pdag(:,b)==-1)' ); % recent correction
    % C contains nodes c s.t. a-c->ba
    Gc = setdiag(pdag(C,C),1);
    G2 = (Gc==0)&(Gc'==0);
    if any(G2(:)==0) % there are 2 different non adjacent elements of C
      pdag(a,b) = -1; pdag(b,a) = 0;
      %fprintf('rule 3: %d -> %d\n', a, b);
    end
  end
end

% convert back to a binary matrix of 1s and 0s
pdag = abs(pdag);