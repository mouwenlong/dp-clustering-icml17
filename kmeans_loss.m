function [ val ] = kmeans_loss( x_data,z_center,n,d,k )
%Calculate k-means loss (not private, only for testing use)
tmpmat=zeros(k,n);
for j=1:k
     tmpmat(j,:)=sum((x_data-z_center(:,j)*ones(1,n)).^2,1);
end;
val=sum(min(tmpmat,[],1));
end

