function tf = isconnected(vSet, al)
k = length(vSet);
tmpAl = al(vSet);
sVSet = sort(vSet);
tf = -1;
for i = 1:k
    a = tmpAl{i};
    a(~ismembc(a,sVSet)) = [];
    tmpAl{i} = a;
end

if any(cellfun('isempty', tmpAl));
    tf = false;
    return
end

lst = [tmpAl{:}];
n = length(lst);

if k == 5 && n == 8
    % Special case for g28
    degSeq = cellfun('length', tmpAl);
    if sum(degSeq == 2) == 3 && sum(degSeq == 1) == 2
        tf = false;
    else
        tf = true;
    end
else
    tf = n>=2*(k-1);
end

if tf == -1
    disp('error')
end

end