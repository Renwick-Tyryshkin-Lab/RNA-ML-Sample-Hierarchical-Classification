function subset = createSubset(data, num_header_rows, features)
% This function creates a subset of the dataset that includes the best 
% features identified in feature selection. 
%
% Input: 
%   data:               cell array of expression data. Rows correspond to the
%                       expression of molecular features (i.e. miRNAs). Columns are 
%                       samples. The first column is assumed to be row labels.
%
%   num_header_rows:    number of rows in 'data' that are column
%                       labels/headers
%
%   features:           cell array of names of features selected for 
%                       inclusion in 'subset'
% Output:
%   subset:             table of expression data for selected features. 
%                       Formatted for input in MATLAB Classification Learner App
%
% Author:       Jina Nanayakkara
% Date:         July 2020

%check input arguments
arguments
    data (:,:) cell 
    num_header_rows double
    features (1,:) cell
end

% For visually selected features, create a data table
[~,~,feature_index]=intersect(features,data(:,1),'stable');
subset=data(feature_index,:);
subset=[data(1:num_header_rows,:); subset]; %include the header rows
subset=subset.'; %transpose to be compatible with MATLAB Classification Learner App
subset=cell2table(subset(2:end,2:end),'RowNames',subset(2:end,1),'VariableNames',subset(1,2:end));
