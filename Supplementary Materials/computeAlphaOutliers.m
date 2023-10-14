function a = computeAlphaOutliers(n)
%computes the alpha for the threshold when looking for outliers. The value of alpha
%depends on the size of the dataset (n). The calculation up to n=300 were computed by 
%Hoaglin et al; Hoaglin, D. C., and Iglewicz, B. (1987) Fine-Tuning Some Resistant Rules for Outlier
%Labeling. Journal of the American Statistical Association 82, 1147-1149
%for n > 300, extrapolation function is used: 0.21*log10(n)+ 1.9;

% INPUT:
% n = size of the dataset (number of samples)
%
% OUTPUT:
% a - alpha value used to compute the threshold for outlier detection
%
% AUTHOR: Kathrin Tyryshkin
% DATE: March 2018

arguments
    n double {mustBeNumeric, mustBePositive}
end

%these are the parameters from the paper
N = [5:20 29:32 37:40 49:52 73:76 97:100 200 300]'; 
P95 = [1.5;1.5;2.0;1.8;1.8;1.8;2.1;2.0;1.9;2.0;2.1;2.1;2.0;2.1;2.2;2.1;2.1;2.1;2.2;2.1;2.2;2.2;2.1;zeros(13,1)+2.2; 2.4;2.4];
P90 = [1.5;1.5;1.5;1.4;1.4;1.5;1.7;1.6;1.6;1.7;1.7;1.7;1.7;1.7;1.8;1.8;zeros(10,1)+1.9; zeros(10,1)+2.0; 2.2; 2.2];

% for debugging and visualization
% alphaEstimator = table(N, P95, P90);
% figure; hold on
% plot(N, P95, 'g-', 'linewidth', 2);
% plot(N, P90, 'b-', 'linewidth', 2);
% t = 0.21*log10(N)+ 1.9;
% plot(N, t, 'c-', 'linewidth', 2);


%compute alpha based on the sample size
if n < 5 %if n is smaller than 5, use a= 1.5
	a = 1.5;
elseif n > 300 %if n is higher than 300 use extrapolation
    a = 0.21*log10(n)+ 1.9;
else %use values provided by the authors
    %find closest n
    ind1 = min(N(n<=N));
    ind2 = max(N(n>=N));
     %take average
    a = (P95(N==ind1)+P95(N==ind2))/2;
end