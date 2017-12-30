function [ z ] = recover( X_data,n,d,epsilon )
%Recover the centers privately from a given cluster
global range;
if(isempty(X_data))
    z=random('unif',-range,range,[d,1]);
else
z=sum(X_data,2)/n;
z=z+random('exp',range/(epsilon*n),[d,1]).*(2*random('bino',1,0.5,[d,1])-1);
end;
end