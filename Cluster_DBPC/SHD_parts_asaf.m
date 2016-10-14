function [ SHD,ME,EE,MD,ED,WD ] = SHD_parts_asaf(L,T)
%[ SHD,ME,EE,MD,ED,WD ] = SHD_parts(L,T)
%SHD_PARTS recieve two CPDAGs L(learned) and T(true) [matrix(n,n) with 0 and 1]
%and returns SHD and its parts (ME, EE, MD, ED, WD - in that order)

ME = 0; %Missing Edges
EE = 0; %Extra Edges
MD = 0; %Missing Directions
ED = 0; %Extra Directions
WD = 0; %Worng Directions

s = length(L(1,:));

for i=1:s
    for j=1:i
        if ~(L(i,j)==T(i,j) && L(j,i)==T(j,i))
            
            
            if (L(i,j)==0 && L(j,i)==0) %ME
                ME = ME+1;
                if ~(T(i,j)==1 && T(j,i)==1)
                    MD=MD+1;
                end
            else if (T(i,j)==0 && T(j,i)==0) %EE
                EE = EE+1;
                if ~(L(i,j)==1 && L(j,i)==1)
                    ED=ED+1;
                end    
            else if (L(i,j)==1 && L(j,i)==1) %MD
                MD = MD+1;
            else if (T(i,j)==1 && T(j,i)==1) %ED
                ED = ED+1;
            else %WD
                WD = WD+1;
                end;
                end;
                end;
            end;
            
        end;
    end
end
SHD = ME+EE+MD+ED+WD;
end

