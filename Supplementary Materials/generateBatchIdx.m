function batch_idx = generateBatchIdx(batch_num)
% This function uses the batch numbers (i.e. sequencing lane ID) to 
% generate an index of boundaries between batches. The  index can be used 
% to plot data and mark different batches. 
%
% Input: 
%   batch_num:    a numeric array of batch numbers in the order of samples.
%                 Samples in the same batch must be grouped together
%
% Output:
%   dataout:      a numeric array indicating the spaces between batches
%
% Author:       Jina Nanayakkara
% Date:         July 2020

%check input arguments
arguments
    batch_num (:,1) {mustBeNumeric}; 
end


% Mark the indices between batches
% assumes samples are sorted by batch
batch_idx=[];
prev_batch_num=batch_num(1);
for i=1:length(batch_num)
    if (batch_num(i)==prev_batch_num)
       prev_batch_num=batch_num(i);
    else
        batch_idx=[batch_idx i-0.5];
        prev_batch_num=batch_num(i);
    end
end