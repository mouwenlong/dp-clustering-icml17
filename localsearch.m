function [ centers ] = localsearch( data,candidate,n,p,k,epsilon )
%Private local search k-means given candidate centers.
%p is dimension
global range;
[~,m]=size(candidate);
weightmat=zeros(m,n);
Lambda=2*range;
for j=1:m
    tmp=candidate(:,j)*ones(1,n)-data;
    weightmat(j,:)=sum(tmp.^2,1);
end;
centerid=random('unid',m,[k,1]);
T=k;
if(T>20)
    T=20;
end;
recordid=zeros(k,T);
recordloss=zeros(T,1);
loss=sum(min(weightmat(centerid,:),[],1));
for iter=1:T
    fprintf('%d-th iteration for local search\n',iter);
    gains=zeros(k,m);
    for i=1:k
        for j=1:m
            tmpcenterid=centerid;
            tmpcenterid(i)=j;
            newloss=sum(min(weightmat(tmpcenterid,:),[],1));
            gains(i,j)=newloss-loss;
        end;
    end;
    raw_exp=exp(-epsilon*gains/(Lambda^2*(T+1)));
    [i,j]=sample_discrete(raw_exp);
    centerid(i)=j;
    recordloss(iter)=sum(min(weightmat(centerid,:),[],1));
    loss=recordloss(iter);
    recordid(:,iter)=centerid;
end;
[iter,~]=sample_discrete(exp(-epsilon*recordloss/(Lambda^2*(T+1))));
centerid=recordid(:,iter);
centers=candidate(:,centerid);
end

