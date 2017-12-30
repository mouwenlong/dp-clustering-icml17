function [ z_centers,clusters,u_centers,c_candidates,L_loss ] = clustering( x_data,n,d,k,epsilon,delta )
%x_data should be d*n matrix, where each column is a data point
%k: number of clusters.
%epsilon: privacy parameter
%delta: failure probability, not used in current implementation (assume constant failure probability)
%Global variables:
%  range=l_2 radius of the data space. Need to specify before using.
%  side_length>2*l_infty norm of data space. Need to specify before using.
global range;
global side_length;
mu_mean=mean(x_data,2);
for iter=1:n
    tmpR=norm(x_data(:,iter)-mu_mean);
    if(tmpR>range)
        range=tmpR;
    end;
end;
T=1;
results=cell(T,1);
loss_iter=zeros(T,1);
epsilon=epsilon/T;
for iter=1:T
    fprintf('Round: %d\n',iter);
    p=floor(0.5*log(n));
    G_projection=random('normal',0,1,[p,d])/sqrt(p);
    if(d<=5)
        p=d;
        G_projection=eye(d);
    end;
    y_projected=G_projection*x_data;
    c_candidates=candidate(y_projected,n,p,k,2*epsilon/3);
    fprintf('Candidate set finished.\n');
    u_centers=localsearch(y_projected,c_candidates,n,p,k,epsilon/12);
    fprintf('Local search finished.\n');
    clusters=cell(k,1);
    for i=1:n
        minval=1e100;
        minindex=0;
        for j=1:k
            dist=norm(y_projected(:,i)-u_centers(:,j));
            if(dist<minval)
                minval=dist;
                minindex=j;
            end;
        end;
    clusters{minindex}=[clusters{minindex},i];
    end;
    z_centers=zeros(d,k);
    totalloss=0;
    for j=1:k
        z_centers(:,j)=recover(x_data(:,clusters{j}),length(clusters{j}),d,epsilon/6);
        totalloss=totalloss+sum(sum((x_data(:,clusters{j})-z_centers(:,j)*ones(1,length(clusters{j}))).^2));
    end;
    fprintf('Starting Lloyd.\n');
    nLloyd=3;%For Lloyd iteration
    for lloyditer=1:nLloyd
        clusters=cell(k,1);
        for i=1:n
            minval=1e100;
            minindex=0;
            for j=1:k
                dist=norm(x_data(:,i)-z_centers(:,j));
                if(dist<minval)
                    minval=dist;
                    minindex=j;
                end;
            end;
            clusters{minindex}=[clusters{minindex},i];
        end;
        z_centers=zeros(d,k);
        totalloss=0;
        for j=1:k
            z_centers(:,j)=recover(x_data(:,clusters{j}),length(clusters{j}),d,epsilon/(2*nLloyd));
            totalloss=totalloss+sum(sum((x_data(:,clusters{j})-z_centers(:,j)*ones(1,length(clusters{j}))).^2));
        end;
    end;
    results{iter}.z_centers=z_centers;
    results{iter}.clusters=clusters;
    results{iter}.c_candidates=c_candidates;
    results{iter}.u_centers=u_centers;
    loss_iter(iter)=totalloss;
    fprintf('Lloyd finished\n');
end;
prob=exp(-epsilon*loss_iter/12);
iter=sample_discrete(prob);
z_centers=results{iter}.z_centers;
clusters=results{iter}.clusters;
c_candidates=results{iter}.c_candidates;
u_centers=results{iter}.u_centers;
L_loss=loss_iter(iter);
end

