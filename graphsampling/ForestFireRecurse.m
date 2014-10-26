function vSet = ForestFireRecurse( vStart, al, pf, visited, start )

currentAl = al{vStart};
p = 1 / (pf/(1-pf) + 1);

x = geornd(p);
x = min([x length(currentAl)]);

start = [start vStart];
fprintf('Visited %d.\n',vStart);

for i = 1:x
    if (all(visited ~= currentAl(i)) && all(start ~= currentAl(i)))
        visited = ForestFireRecurse( currentAl(i), al, pf, visited, start );
    end
end

vSet = [vStart visited];
    