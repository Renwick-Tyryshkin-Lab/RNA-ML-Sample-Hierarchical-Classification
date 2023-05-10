function [ normalized_data ] = sampleNormalizationRF( datain )
% This fucntion computes sample normalization
%             Computes the sum of values for each column in the matrix and 
%             divides each value in a column of the matrix by its sum.
%
% Input:
%   inputdata:        double array of expression data, where each
%                     column is a sample and each row is a unique molecule (ie. gene or miRNA)
% 
% Output:
%   outputdata:       double array of expression data normalized to the total
%                     per column
%
% Author:           Kathrin Tyryshkin
% Date:

    %check input arguments
    arguments
        datain (:,:) {mustBeNumeric};
    end
    
    % Sum each column of the datain matrix to use for normalization
    sum_cols = sum(datain);

    % Perform normalization by dividing each value in column by the sum of that column
    normalized_data = datain ./ sum_cols;
    
end

