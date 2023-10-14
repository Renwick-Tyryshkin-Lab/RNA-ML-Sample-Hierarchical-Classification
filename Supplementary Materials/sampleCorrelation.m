function corr_result = sampleCorrelation(datain, corrtype)
%Description: For each sample (column) in an input matrix, compute an average
%             correlation to all other samples (columns). Correlation type 
%             is specified as second input.
%             Returns a vector of the average correlation for each column.
%
%INPUT:  - datain: matrix of samples to compute correlations from, samples
%                  are columns, type double
%        - corrtype: string or char array indicating correlation type to use
%
%OUTPUT: - sample_corr: vector of average correlations for each
%                            sample (column) to all other samples

%check input arguments
arguments
    datain double
    corrtype char {mustBeMember(corrtype,{'Spearman','Pearson'})} = 'Spearman ';
end

%compute correlation
rho = corr(datain, 'Type', corrtype);

%remove correlation between column and itself, set diagonal of the matrix to NaN
s = size(rho);
index = 1:s(1)+1:s(1)*s(2);  % Indices of the main diagonal
rho(index) = NaN;

% Find the average correlation for each column in input, omit NaNs
corr_result = mean(rho,1,'omitnan');
    

end
