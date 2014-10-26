function type = GetGraphletType(vSet, tmpAl, k)

switch k
    case 3
        for i = 1:3
            a = tmpAl{i};
            if sum(ismember(a,vSet)) ~= 2;
                type = 1;
                return
            end
            type = 2;
        end
        
    case 4
        for i = 1:4
            a = tmpAl{i};
            a(~ismember(a,vSet)) = [];
            tmpAl{i} = a;
        end        
        lst = [tmpAl{:}];        
        n = length(lst); % 2*|E|
        if n == 12
            type = 1;
        elseif n == 10
            type = 2;
        elseif n == 8
            if any(cellfun(@length, tmpAl)==3)
                type = 3;
            else
                type = 5;
            end
        elseif n == 6
            if any(cellfun(@length, tmpAl)==3)
                type = 4;
            else
                type = 6;
            end                   
        else
            disp('Error')
            type = -1;
        end                    
        
    case 5
        lst = [tmpAl{:}];
        lst(~ismembc(lst, sort(vSet))) = [];
        n = length(lst);
        degList = sort(cellfun('length', tmpAl));
        switch n            
            case 20 % Can only be fully connected
                type = 1;
            case 18
                type = 2; % only one type w. 9 edges
            case 16
                if degList(1) == 2
                    type = 4;
                else
                    type = 3;
                end
            case 14
                % Type 5, 6, 9 or 14
                if degList(1) == 1
                    type = 9;
                elseif degList(2) == 3;
                    type = 5;
                elseif degList(3) == 2;
                    type = 14;
                else
                    type = 6;
                end                    
                
            case 12 
                % Type 7, 10, 11, 15 or 16
                if degList(1) == 1 && degList(5) == 4
                    type = 16;
                elseif degList(1) == 1 && degList(5) == 3
                    type = 10;
                elseif degList(4) == 2;
                    type = 11;
                else
                    idx = find(degList == 3);
                    v = vSet(idx(2));
                    a = tmpAl{idx(1)};
                    if any(ismembc(a, v))
                        type = 7;
                    else
                        type = 15;
                    end
                end
                
            case 10
                % Type 8, 12, 17 or 18
                if degList(1) == 2
                    type = 8;
                elseif degList(2) == 1
                    type = 18;
                else
                    idx = [find(degList == 3), find(degList == 1)];
                    v = vSet(idx(1));
                    a = tmpAl{idx(2)};
                    if a == v
                        type = 17;
                    else
                        type = 12;
                    end
                end                                    
            case 8
                if degList(5) == 4
                    type = 21;
                else
                    type = 20;
                end
        end
end
end