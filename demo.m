%% global variables that need to be set before calling the main function clustering
global range;
global side_length;

%% example 1: clustering synthetic data
d = 100;
k = 2;
rand_center = 10*normc(randn(d, k));
n = 1000;
rand_data = normc(randn(d, n));
n0 = floor(n/k); % #points per cluster
for i = 1:k
    bid = 1+(i-1)*n0;
    eid = i*n0;
    rand_data(:, bid:eid) = rand_data(:, bid:eid) + rand_center(:,i) * ones(1,n0); 
end

epsilon = 0.5;
delta = 0.1;
range=4;
side_length=4;
[ z_centers,clusters,u_centers,c_candidates,L_loss ] = clustering(rand_data,n,d,k,epsilon,delta);


%% example 2: clustering MNIST data; please download the data first
if ~exist('mnist.mat', 'file')
    fprintf('Please download MNIST and preprocess to a mat file\n');
    exit;
end
load('mnist.mat');
% mnist.mat should contain a matrix called mnist, which should be a d*n matrix, where each column is a data point
k=10;
d=784;
n=70000;
eps=1;
delta=0.1;
range=255*sqrt(784);
side_length=510;
[ z_centers,clusters,u_centers,c_candidates,L_loss ]=clustering(mnist,n,d,k,eps,delta);

