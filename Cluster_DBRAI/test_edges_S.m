function [Gend,seps,probArr] = test_edges_S(P,C,G,ex_nodes,s_nodes,class_node,Seps,ProbArr,n,cond_indep,data,varargin)
global NCI
%global MI
th=varargin{1,1};
len_p = length(P);
probArr=ProbArr;
%len_MI = length(MI);

% % sort edges to be tested according to their mutual information value -----
% MInf = MI(P+(C-1)*len_MI);
% [MIs, I] = sort(MInf);
% P = P(I);
% C = C(I);
% % -------------------------------------------------------------------------

fid=-1;
sv=find(strcmp(varargin,'savefile'));
if length(sv>0)
    sv=sv(1);
    sfname=varargin(sv+1);
%     varargin=varargin([1:(sv-1),sv+2:end]);
    fid=fopen(sfname,'at');
else
    fid=-1;
end
Gend=G;
Gs = zeros(size(G));
r_nodes = union(ex_nodes,s_nodes);
Gs(r_nodes,r_nodes) = G(r_nodes,r_nodes);

seps=Seps;

CI_tests=cell(max([P;C;0])); % record of conducted CI test. Used to eliminate redundant tests.
% ns=max(data);
% N=size(data,1);
for k = 1:len_p
    if (n~=0)
%         pa = find(Gend(:,C(k)));% identify the parents of the child node % G->Gend
%         par=mysetdiff(pa,P(k));
%         pa = find(Gend(P(k),:));% identify the parents of the child node % G->Gend
%         par=mysetdiff(pa,C(k));
        par=unique(mysetdiff(neighbors(Gend, C(k)), P(k)));
%         par=unique(mysetdiff(neighbors(Gend, P(k)), C(k)));


%         Gp = Gs; Gp(C(k),:)=0; Gp(:,C(k))=0; % remove the child node
%         RG = reachability_graph(double(Gp | Gp')); % identify the nodes connected to the parent node
%         par = intersect(setdiff(find(RG(P(k),:)),P(k)),pa);
            
        S = subsets1(sort(par),n); % select a condition set with size n from the parents group
    else
        S = {[]};
    end
%     cond_seps=cell(length(S),2);
%     q=1;
%     flag=0;
    for si = 1:length(S)
        if ((Gend(P(k),C(k))==1) || (Gend(C(k),P(k))==1))
            % % %         fprintf('CI test: %d and %d given\t',P(k),C(k));
            % % %         fprintf('%d ',S{si});
            % % %         fprintf('\n');
            ci_record=sprintf('%d,',sort(S{si}));
            s_pair=sort([P(k),C(k)]);
            if ~isempty(CI_tests{s_pair(1),s_pair(2)})
                a=sum(strcmp(CI_tests{s_pair(1),s_pair(2)}(:),ci_record)); % check if test was previously conducted
            else
                a=0;
                CI_tests{s_pair(1),s_pair(2)}{1}=ci_record;
            end
                
            if a==0
                CI_tests{s_pair(1),s_pair(2)}{end+1}=ci_record;
                NCI(length(S{si})+1) = NCI(length(S{si})+1) + 1;
                
                                    
                [threshold_val,df]=s1cond(P(k),C(k), [S{si},class_node],data, th);
                [CI, I]=mutual2_decision(P(k),C(k), [S{si},class_node], data,threshold_val);
%                 [CI,~,I]=cond_indep_g2(P(k),C(k), [S{si},class_node], data,th);
                if (fid>0) % write to file
                    len=length(S{si});
                    fprintf(fid,'%d,%d,%d',P(k),C(k),len);
                    if len~=0
                        fprintf(fid,',%d',S{si});
                    end
                    fprintf(fid,',%f,%f,%d\n',I,threshold_val,CI); % mutual information value (not supported yet)
                end
                if CI
                        seps{P(k),C(k)} = S{si};
                        seps{C(k),P(k)} = S{si};
                        Gend(P(k),C(k)) = 0;
                        Gend(C(k),P(k)) = 0;
                        Gs(P(k),C(k)) = 0;
                        Gs(C(k),P(k)) = 0;
                        lnk = 0;
                        %fprintf('edge(%d,%d) was removed\n',P(k),C(k));
                    
                    break
                end
%                 if CI
%                         cond_seps{q,1}=S{si};
% %                         cond_seps{q,2}=1-chisquared_prob(I*N*2,df);
%                         cond_seps{q,2}=I;
%                         q=q+1;
%                         flag=1;
%                 end
            end
        end
    end
%    if flag
%         tmp=cell2mat(cond_seps(:,2));
%         [~,tmpMax]=max(tmp);
%         seps{P(k),C(k)} = cond_seps{tmpMax,1};
%         seps{C(k),P(k)} = cond_seps{tmpMax,1};
%         probArr(P(k),C(k)) = cond_seps{tmpMax,2};
%         probArr(C(k),P(k)) = cond_seps{tmpMax,2};
%         Gend(P(k),C(k)) = 0;
%         Gend(C(k),P(k)) = 0;
%         Gs(P(k),C(k)) = 0;
%         Gs(C(k),P(k)) = 0;
%         lnk = 0;
%         %fprintf('edge(%d,%d) was removed\n',P(k),C(k));
%     end 
end
if fid>0
    fclose(fid);
end
clear NCI