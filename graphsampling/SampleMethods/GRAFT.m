function cg = GRAFT(am, al, g, p)
%GRAFT Sampling using GRAFT algorithm
%  An Approximate Graphlet Counting Algorithm for Large Graph Analysis, 
%  Bhuiyan et al. (2012)
  
% g either 3,4,5


[ii, jj] = find(am);
nbrEdges = length(ii);
nbrSamples = round(nbrEdges * p);

sampleIdx = randperm(nbrEdges, nbrSamples);
Ep = [ii(sampleIdx), jj(sampleIdx)];


count = 0;
for i = 1:nbrSamples
    iE = Ep(i,:);
    id1 = iE(1);
    id2 = iE(2);
    
    
   switch g       
       case 3
           a1 = al{id1};
           a2 = al{id2};
           a2(a2==id1) = [];
           a1(a1==id2) = [];
           
           u12 = ismembc(a2, sort(a1));
           count = count + sum(~u12);                     
%            for j = 1:length(a2)
%                id3 = a2(j);
%                isHp = ~any(a1 == id3);
%                count = count + isHp;
%            end
       case 4
           a1 = al{id1};
           a2 = al{id2};
           a2(a2==id1) = [];
           a1(a1==id2) = [];
           
           if length(a2) >= 2
               a3 = a2;
               for j = 1:length(a3)
                   id3 = a3(j);
                   a4 = a3;
                   a4(a4 == id3) = [];
                   for k = 1:length(a4)
                       ad = al{a4(k)};
                       isStr = ~any( or( ad == id1, ad == id3 ) );
                       count = count + isStr*1/3;
                   end
               end
           end
           
       case 5
           
           a1 = al{id1};
           a2 = al{id2};
           a2(a2==id1) = [];
                      
           if length(a2) >= 3
               a3 = a2;
               for j = 1:length(a3)
                   id3 = a3(j);
                   a4 = a3;
                   a4(a4 == id3) = [];
                   for k = 1:length(a4)
                       id4 = a4(k);
                       a5 = a4;
                       a5(a5 == id4) = [];
                       for l = 1:length(a5)
                           ad = al{a5(l)};
                           isStr = ~any( ad == id1 | ad == id3 | ad == id4 );
                           count = count + isStr*1/12;
                       end                                              
                   end
               end
           end
   end

end

cg = (count/2)/p;

end


