function [vSet, flag] = RandomWalk(al, k)
n = length(al);
idx = randi(n);
vSet = zeros(k,1);
vSet(1) = idx;
flag = false;

i = 2;
dec = 0;
while any(~vSet)
    at = al{vSet(i-(1+dec))};
    a = at(~ismemberfastscalar(at, vSet(1:i)));
%     a = at;
%     a(ismembc(at, sort(vSet(1:i))))=[];
%     
    if ~isempty(a)
        iN = length(a);
        iIdx = randi(iN);
        vSet(i) = a(iIdx);
        i = i+1;
        dec = 0;
    else
        dec = dec + 1;
        if 1+dec == i
            flag = true;
            return
        end        
    end  
end

end

