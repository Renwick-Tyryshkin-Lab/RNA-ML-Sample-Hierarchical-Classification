%% Load data into MATLAB 

% Columns correspond to samples and rows to miRNAs or features, header rows
% store information about samples (e.g. sample IDs, class labels, 
data = readcell('project_data/Supplementary_Table1.csv');

% Row and column number where numeric expression data starts in data variable
row_start = 5;
col_start = 2;

% Sort the data by Lane ID/ batch information 
sort_by_row = 2; % Lane ID info is in row 2 of data variable

sort_by_data = cell2mat(data(sort_by_row, col_start:end));
[sort_by_data,sort_idx]=sort(sort_by_data); % Stores boundaries for batches in sorted data variable
data = data(:,[1:col_start-1 sort_idx+col_start-1]); % Rearrange data by batch ids

%% Normalize data 
% In each sample, the sequencing reads of individual miRNA molecules are
% normalized to the total sequencing reads observed in that sample. This is
% known as relative frequency normalization.

norm_data = data;
norm_data(row_start:end, col_start:end) = ...
    num2cell(sampleNormalizationRF(cell2mat(data(row_start:end, col_start:end))));

% -------------------------------------------------------------------------
%------------------ Repeat preprocessing steps from here ------------------
%% Visualize data with boxplots 
% Plot boxplots of miRNA expression for each sample and mark boundaries
% between batches

% Log2 transformation (optional) approximates a normal distribution and
% improves data visualization in subsequent steps so that outliers can
% easily be detected.

% Replace zeros and log2 transform
transform_data = log2(replaceZeros(cell2mat(norm_data(row_start:end, col_start:end)),'lowval'));

% Visualize variability with boxplots for each sample
makeBoxplot(transform_data, norm_data(1, col_start:end), ...
    'Samples', 'log_2 normalized expression',sort_by_data,'showTickLabels',false);

% Set filtering parameters
threshold = 0.9; % Quantile level for filtering
percent = .05; % Percent of samples which must pass the threshold
category_row = 4; % Row in which the grouping labels are stored

% Find the logical indices for features to remove, 1 (remove) 0 (keep)
ind_to_rm = markLowCountsInGroups(cell2mat(norm_data(row_start:end, col_start:end)), ...
    threshold, percent, categorical(norm_data(category_row,col_start:end)));

% Only keep features that are not below the filtering threshold
filt_data = transform_data(~ind_to_rm,:);

% Plot the filtered miRNA expression distributions as boxplots
makeBoxplot(filt_data, norm_data(1, col_start:end), ...
    'Samples', 'log_2 normalized expression',sort_by_data,'showTickLabels',false);

%% Detect sample outliers and/or batch effects 
% Initialize variables for samples to remove and investigate further
samples2remove = {};
samples2investigate = {};

%% Calculate and plot mean spearman correlation
% Calculate mean Spearman correlation
mean_corr = ...
    sampleCorrelation(cell2mat(norm_data(row_start:end, col_start:end)), 'Spearman');

% Visualize with scatterplot
[corr_outliers,corr_outliers_IDs] = scatterplotMarkOutliers(mean_corr, ...
    'ColumnLabels', norm_data(1, col_start:end), ...
    'xlabel','Samples',...
    'ylabel', 'Mean Spearman correlation',...
    'PlotTitle','Mean Spearman correlation between miRNA profiles',...
    'Batch', sort_by_data,'ShowXTickLabel',false);

% Add samples to samles2remove and/or samples2investigate (if applicable)
% Remove entire batch
batch2remove = [183,205];
samples2remove = [samples2remove ; norm_data(1, [false(1,col_start-1), ...
    ismember(sort_by_data,batch2remove)])'];

% Remove specific samples
samples2remove = [samples2remove ; {'INET 17';'PanNET 29'}];

% Add samples to samples2investigate
samples2investigate = [samples2investigate; {'NB 27';'NB 28';'AppNET 1';'AppNET 8'; 'INET 22'; 'PanNET 13';'LCNEC 16'}];
%% Investigate potential outliers and/or batch effects with IQR 
% OPTIONAL: Replace zeros and log2 transform
transform_data = log2(replaceZeros(cell2mat(norm_data(row_start:end, col_start:end)),'lowval'));

% Calculate IQR for each sample
iqr_data = iqr(transform_data);

% Visualize with scatterplot
[iqr_outliers, iqr_outliers_IDs] = scatterplotMarkOutliers(iqr_data, ...
    'ColumnLabels', norm_data(1, col_start:end),...
    'xlabel', 'Samples',...
    'ylabel', 'IQR',...
    'PlotTitle','RF Normalized IQR', ...
    'Batch',sort_by_data,'ShowXTickLabel',false);

% Remove samples based on IQR plot 
samples2remove = [samples2remove ; {'NB 27'; 'INET 22'; 'PanNET 13'; 'LCNEC 16'; 'PanNET 14'}];

% Remove any samples from samples2investigate that were added to
% samples2remove
[~,ind] = intersect(samples2investigate,samples2remove,'stable');
samples2investigate(ind) = [];

%% Investigate potential outliers and/or batch effects with hierarchical clustering 
% OPTIONAL: Replace zeros and log2 transform
transform_data = log2(replaceZeros(cell2mat(norm_data(row_start:end, col_start:end)),'lowval'));

% Median center the log2 transformed data
transform_data_median_centered = transform_data - median(transform_data, 'all');

% Select display range through boxplot assessment, based on the upper
% quartile of majority of the plotted boxes
makeBoxplot(transform_data_median_centered, ...
    norm_data(1, col_start:end), 'Samples', 'log_2 normalized median centered expression',sort_by_data,'showTickLabels',false);

display_range = 7;

% Generate clustergram
cg = clustergram(transform_data_median_centered,...
    'RowLabels', norm_data(row_start:end, 1), ...
    'ColumnLabels',norm_data(1, col_start:end), ...
    'ColumnPDist','spearman',...
    'RowPDist','euclidean',...
    'Colormap',custom_colorMap_RedBlue,...
    'DisplayRange',display_range);

%% Remove individual sample outliers and batch effects 
% Find indices of samples to remove (stored in samples2remove)
[~,idx2rm] = intersect(norm_data(1, col_start:end),samples2remove,'stable');

% Remove outlier samples from the dataset by setting outlier columns to empty
norm_data (:,idx2rm+col_start-1) = [];
sort_by_data(:,idx2rm) = [];

% Repeat above preprocessing steps to iteratively determine additional
% outliers (from Visualize data with boxplots) 
% -------------------------------------------------------------------------
%% Filter the low expressed features in processed data 
% Set filtering parameters
threshold = 0.9;
percent = .05;
category_row = 4;

% Mark samples below filtering threshold
mark2remove = markLowCountsInGroups(cell2mat(norm_data(row_start:end, col_start:end)),...
    threshold, percent, categorical(norm_data(category_row, col_start:end)));

% Remove low expressed features/miRNAs from final_filt_data
final_filt_data = norm_data;
headers = false(row_start-1,1);
final_filt_data([headers; mark2remove], :) = [];

% OPTIONAL: Remove STAR miRNAs 
feature_names = final_filt_data(row_start:end,col_start-1);
ind_to_rm = contains(feature_names,{'STAR','*','star'});
headers = false(row_start-1,1);
final_filt_data ([headers; ind_to_rm], :) = [];

% Plot the final filtered miRNA expression distributions as boxplots
transform_data = log2(replaceZeros(cell2mat(final_filt_data(row_start:end,col_start:end))));
makeBoxplot(transform_data, norm_data(1, col_start:end), ...
    'Samples', 'log_2 normalized expression',sort_by_data);

%% Save and write the final dataset
% Run below commands to store final data without outlier samples
final_transform_data = transform_data;
final_norm_data = norm_data;

% Clear variables not required for subsequent stages
clearvars -except final_norm_data final_transform_data final_filt_data col_start row_start

% Save workspace 
save (fullfile('project_data','Stage1_workspace.mat'), 'final_norm_data', 'final_transform_data', 'final_filt_data', 'col_start', 'row_start')

%output the final datasets (filtered and transformed data - 'final_filt_data';
%normalized data - 'final_norm_data')
writecell(final_filt_data,fullfile('results_data','final_filt_dataset.csv'));
writecell(final_norm_data,fullfile('results_data','final_norm_dataset.csv'));