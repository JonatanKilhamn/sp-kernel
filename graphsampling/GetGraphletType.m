function type = GetGraphletType(vSet, am, k)

[degList, sortInd] = sort(full(sum(am))); 

switch k
    case 3
        if degList(1) == 2
            type = 1;
        else
            type = 2;                
        end
        
    case 4                
        n = sum(degList); % 2*|E|
        if n == 12
            type = 1;
        elseif n == 10
            type = 2;
        elseif n == 8
            if degList(4) == 3;
                type = 3;
            else
                type = 5;
            end
        elseif n == 6
            if degList(4) == 3;
                type = 4;
            else
                type = 6;
            end                           
        end                    
        
    case 5
        n = sum(degList);
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
                    if am(sortInd(idx(1)),sortInd(idx(2)));
                        type = 7;
                    else
                        type = 15;
                    end
                end
                
            case 10
                % Type 8, 12, 17, 18 or 19
                if degList(1) == 2
                    type = 8;
                elseif degList(2) == 1 && degList(5) == 3                   
                    type = 18;
                elseif degList(2) == 1
                    type = 19;
                else
                    idx = [find(degList == 3), find(degList == 1)];
                    if am(sortInd(idx(1)),sortInd(idx(2)))
                        type = 17;
                    else
                        type = 12;
                    end
                end                                    
            case 8
                if degList(5) == 4
                    type = 21;
                elseif degList(5) == 3
                    type = 20;                    
                else
                    type = 13;
                end
        end
end
end