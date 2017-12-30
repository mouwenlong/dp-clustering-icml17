function [ id ] = sample_discrete_1d( v )
%Sample from pmf vector, return index
[m,~]=size(v);
if(m==1)
    v=v';
end;
[id,~]=sample_discrete(v);

end

