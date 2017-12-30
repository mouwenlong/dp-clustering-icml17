function [rowid,colid] = sample_discrete(A)
%Sample from a matrix proportional to the entry value, return row and
%column indices.
[k,m]=size(A);
totalsum=sum(sum(A));
randomcoin=random('unif',0,totalsum);
currsum=0;
for i=1:k
    for j=1:m
        currsum=currsum+A(i,j);
        if(currsum>=randomcoin)
            break;
        end;
    end;
    if(currsum>=randomcoin)
         break;
    end;
end;
rowid=i;
colid=j;
end

