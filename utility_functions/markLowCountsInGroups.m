function mark2remove = markLowCountsInGroups(datain, cutoff, percent, groups)
% Description:
%   Purpose: To identify the features that do not reach a threshold value
%   in a given % of samples under investigation, segregated by sample
%   grouping
%   INPUT:
%        datain - a 2D martix of type double  where each column is a sample and each row is a feature
%        cutoff - an integer value to indicate quartile level to establish threshold value
%        percent - percent of samples that must pass the threshold
%        groups - sample labeling
%   OUTPUT:
%       mark2remove - a boolean vector indicating which features are marked to be below the threshold.
%   
%   Author: Kathrin Tyryshkin    

%check input arguments
arguments
    datain (:,:) {mustBeNumeric}; 
    cutoff double {mustBeLessThanOrEqual(cutoff, 1), mustBeGreaterThanOrEqual(cutoff, 0)}
    percent double {mustBeLessThanOrEqual(percent, 100), mustBeGreaterThan(percent, 0)}
    groups (1,:) {mustBeEqualLength(datain, groups)} = categorical(ones(1,size(datain,2)));
end

%convert percent into # of samples that must pass the threshold
[grcount, ~] = grp2idx(groups);
n = histcounts(groups)';
numToCut = (percent.*n)./100;

%initialize matrix to mark features below threshold in each group
flagsPerGroup = false(size(datain, 1), length(n));

%calculate the threshold
temp = reshape(datain, [1 size(datain,1)*size(datain,2)]);
threshold = quantile(temp, cutoff);

locsAboveThreshold = datain >= threshold;

%row sum will be 0 for feature that never meets threshold
for j=1:length(n)
    flagsPerGroup(:,j) = sum(locsAboveThreshold(:,grcount==j),2) <= numToCut(j);
end
%for all groups the features are below the threshold for the specified % of
%samples
mark2remove = sum(flagsPerGroup, 2)== length(n);
end

% Custom validation function
function mustBeEqualLength(a,b)
    % Test if a and b have equal number of columns 
    if ~isequal(size(a(1,:)),size(b))
        error('Number of columns in the first input must equal size of second input')
    end
end
