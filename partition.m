function [ gridpoints ] = partition( X_data,n,p,epsilon )
%Partitioning using the regular grid.
global side_length;
gridpoints=[];
depth=1;
epss=epsilon/(2*log(n));
gamma=2*log(n)/epss;
thegrid=cell(1);
thegrid{1}.coordinate=zeros(p,1);
thegrid{1}.points=(1:n);
while((depth<log(n))&&(~(isempty(thegrid))))
    L=length(thegrid);
    side_length=side_length/2;
    newgrid=cell(0);
    for j=1:L
        gridpoints=[gridpoints,thegrid{j}.coordinate];
        npoints=length(thegrid{j}.points);
        directions_numeric=sign(X_data(:,thegrid{j}.points)-thegrid{j}.coordinate*ones(1,npoints));
        directions=num2cell(num2str(directions_numeric'),2);
        numericmap=containers.Map(directions,num2cell(directions_numeric,1));
        cubemap=containers.Map(directions,cell(npoints,1));
        for i=1:npoints
            cubemap(directions{i})=[cubemap(directions{i}),i];
        end;
        keyset=keys(cubemap);
        valset=values(cubemap);
        for i=1:length(cubemap)
            activesize=length(valset{i});
            if(activesize>gamma)
                prob=1-0.5*exp(-epss*(activesize-gamma));
            else
                prob=0.5*exp(epss*(activesize-gamma));
            end;
            if(random('bino',1,prob)>0.5)
                tempobj.coordinate=thegrid{j}.coordinate+side_length/2*numericmap(keyset{i});
                tempobj.points=valset{i};
                newgrid=[newgrid,tempobj];
            end;
        end;
    end;
    thegrid=newgrid;
    depth=depth+1;
end;
end

