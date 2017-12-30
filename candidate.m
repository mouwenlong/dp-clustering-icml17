function [ candidates ] = candidate(X_data,n,p,k,epsilon)
%Find candidate centers given data points.
T=2;
global side_length;
candidates=[];
newpart=partition(X_data,n,p,epsilon/T);
candidates=[candidates,newpart];
for t=1:T
    fprintf('%d-th trial for candidate set\n',t);
    offset=random('unif',-side_length/2,side_length/2,[p,1]);
    shifted=X_data+offset*ones(1,n);
    newpart=partition(shifted,n,p,epsilon/T);
    [~,L]=size(newpart);
    newpart=newpart-offset*ones(1,L);
    candidates=[candidates,newpart];
end;
end

