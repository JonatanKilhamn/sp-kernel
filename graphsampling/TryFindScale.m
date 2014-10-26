addpath(genpath([pwd '/..']));

load DD
dSet = 6;
n = 10;
t = 1e6;

nbrReject = zeros(n,1);

am = DD(dSet).am;
al = DD(dSet).al;
% for i = 1:n    
%     [~, iReject ] = AcceptReject(am, al, 4);
%     nbrReject(i) = iReject;
%     disp(i/n)
% end
% avgSamplingRatio = mean(nbrReject);
% qHat = n / (sum(nbrReject)+n);

nbrConnected_sample = AcceptReject2(am,al,4,t);
qHat = nbrConnected_sample / t;

nbrGraphlets = nchoosek(length(al), 4);
nbrConnected = sum(countconnected4graphlets(am, al));
q = nbrConnected / nbrGraphlets;
expReject = 1/q;

% str = 'Expected rejections: %0.4e Calculated rejections %0.4e\n';
% fprintf(str, expReject, avgSamplingRatio);

fprintf('qhat: %0.4e \t q: %0.4e\n',qHat,q);
fprintf('nHat: %0.4e \t n: %0.4e\n',qHat*nbrGraphlets,nbrConnected);

% figure(1)
% plot(nbrReject-expReject);
% mean(nbrReject-expReject)



% 
% for i = dSet    
%     for j = 1:length(n)
%         jN = n(j);
%         vSet = cell(1, jN);
%         iVec = zeros(1,jN);
%         for k = 1:jN
%             [t1, t2] = AcceptReject(DD(i).al, DD(i).am, 4);
%             vSet{k} = t1;
%             iVec(k) = t2;
%             disp(k/jN)
%         end
%         
%         freq = SampleGraphlets(DD(i).al, DD(i).am, 4, jN, 'mhs', 25)./jN;
%         freq2 = countconnected4graphlets(DD(i).am, DD(i).al);
%     end    
% end
% 
% disp(mean(iVec))
% disp(freq)
% disp(freq*mean(iVec))
% disp(freq2)