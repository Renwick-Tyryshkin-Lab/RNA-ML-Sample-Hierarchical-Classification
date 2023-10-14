function [final_training_data, final_validation_data] = splitData(datain, sample_label_row, validation_perc)
% This function will divide a dataset of expression profiles into a 
% validation set and training set with balanced sample types
%
%
% Input:
%   datain:             a cell array where rows correspond to expression of
%                       molecular features and columns correspond to samples.
%                       note: the first rows may contain sample labels, sample
%                       types, or sample groups; the first column must be the
%                       labels of each molecular feature
%   sample_label_row:   the row in 'datain' containing sample types or
%                       groups. based on these sample labels, equal proportions 
%                       of each sample type will be included in the training and 
%                       validation data
%   validation_perc:    percentage of dataset to reserve for hold-out
%                       validation (i.e. 0.2, 0.3)
%
% Output:
%   final_training_data:a cell array containing the training dataset
%   final_validation_data: a cell array containing the validation dataset
%
% Author:               Jina Nanayakkara
% Date:                 July 2020

arguments
    datain (:,:) cell 
    sample_label_row double
    validation_perc double
end

% Define the sample types to balance between the training and validation
% datasets
sample_label=datain(sample_label_row,:);

% Initialize output and find the unique sample types
final_training_data={};
final_validation_data={};
unique_sample_types=unique(sample_label(2:end)); 

% For each sample type, randomly choose the validation data and keep the 
% rest as training data
for i=1:length(unique_sample_types)
   
   % Retrieve samples of the same type
   data_index=contains(sample_label,unique_sample_types(i));
   training_data=datain(:,data_index);
   
   % Randomly select samples to be in the validation set, remove these from
   % the training set
   sample_num=size(training_data,2); % number of samples of this type
   validation_index = randperm(sample_num,round(validation_perc*sample_num));
   validation_data=training_data(:,validation_index);
   training_data(:,validation_index)=[];
   
   % Add to final_validation_data and final_training_data
   final_validation_data=[final_validation_data validation_data];
   final_training_data=[final_training_data training_data];
end

% Add the feature labels to final_validation_data and final_training_data
final_validation_data=[datain(:,1) final_validation_data];
final_training_data=[datain(:,1) final_training_data];