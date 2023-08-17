% Load validation and training data 
load trainingValidation_data.mat
%% Feature selection for midgut vs non-midgut (level 1 node 1 and node 2)
% Indicate the start of the numeric expression data in training_data
row_start = 4;
col_start = 2; 

% Row number for class labels in training_data
category_row = 2;

% Class labels for feature selection
category_labels = training_data(category_row,col_start:end);

% feature selection using a built in feature selection algorithm
[idx,scores] = fscmrmr(cell2mat(training_data(row_start:end,col_start:end))',category_labels);

% Plot predictor importance scores
bar(scores(idx))
xlabel('Predictor rank')
ylabel('Predictor importance score')

% Select top X features, retrieve indices for these features in
% training_data
idx = idx(1:5)+row_start-1;

% Retrieve expression data for selected features
resultRankedCellData_level1node1 = training_data([1:row_start-1 idx],:); 
selectedFeatures_level1node1 = training_data(idx,1);

%% Visaulize with hierarchical clustering and t-SNE
% Prepare the data for plotting  
% Extract numeric data only 
numeric_data = cell2mat(resultRankedCellData_level1node1(row_start:end, col_start:end));
% Optional - log2 transform 
transform_data = log2(replaceZeros(numeric_data,'lowval'));
% Median center the data 
data_median_centered = transform_data - median(transform_data, 'all');

% Select display range through boxplot assessment, display range can be any 
% number between the upper range and the upper quartile. Ideally the upper
% boundary of majority of the boxes
makeBoxplot(data_median_centered, ...
    resultRankedCellData_level1node1(1, col_start:end), ...
    'samples', 'log_2 normalized median centered expression');

display_range = 4; 

% Create the labelled clustergram

% Create the hierarchical clustering with the heatmap
cg = clustergram(data_median_centered, ...
    'ColumnLabels',resultRankedCellData_level1node1(1,col_start:end),...
    'RowLabels',resultRankedCellData_level1node1(row_start:end,1),...
    'RowPDist', 'euclidean',... %Select the distance metric for row clustering. 
    'ColumnPDist', 'spearman', ... %Select the distance metric for column clustering. 
    'Linkage','complete',... % Select the linkage method for generating clusters
    'Colormap', custom_colorMap_RedBlue,...
    'DisplayRange', display_range, ... %adjust to data
    'DisplayRatio', 0.1,...
    'LabelsWithMarkers', true);

% OPTION a: Add color labels for one category - e.g. embryological origin
colors = [0.96 0.26 0.44 % pink, non-midgut
         0.26 0.74 0.96]; % blue, midgut

color_labels = clustergramLabel(resultRankedCellData_level1node1(1,col_start:end),category_labels,colors);
set(cg, 'ColumnLabelsColor', color_labels);

% t-SNE
% Optional: generate a tSNE plot with log2 transformed data
tSNE_data=tsne(transform_data.'); % If plotting with un-transformed data, use numeric_data instead of transform_data

% Plot the t-SNE reduction in data dimensionality
figure; gscatter(tSNE_data(:,1),tSNE_data(:,2),category_labels',colors,[],25);

%% Separate by node
ind_node = strcmp(category_labels,'Midgut');

% Midgut: INET vs AppNET - only midgut samples
subset_level2node1 = training_data(:,[true([1 col_start-1]) ind_node]);

ind_node = strcmp(category_labels,'Non-midgut');

% Non-midgut: PanNET vs RNET - only non-midgut samples
subset_level2node2 = training_data(:,[true([1 col_start-1]) ind_node]);

%% Feature selection for INET vs AppNET
% Row number for class labels 
category_row = 3;

% class labels
category_labels = subset_level2node1(category_row,col_start:end);

% feature selection
[idx,scores] = fscmrmr(cell2mat(subset_level2node1(row_start:end,col_start:end))',category_labels);

% Plot predictor importance scores
bar(scores(idx))
xlabel('Predictor rank')
ylabel('Predictor importance score')

% Indices of top X selected featues
idx = idx(1:2)+row_start-1;

% Expression data for selected features
resultRankedCellData_level2node1 = subset_level2node1([1:row_start-1 idx],:); 
selectedFeatures_level2node1 = subset_level2node1(idx,1);

% Prepare the data for plotting  
% Extract numeric data only 
numeric_data = cell2mat(resultRankedCellData_level2node1(row_start:end, col_start:end));
% Optional - log2 transform 
transform_data = log2(replaceZeros(numeric_data,'lowval'));
% Median center the data 
data_median_centered = transform_data - median(transform_data, 'all');

% Select display range through boxplot assessment, display range can be any 
% number between the upper range and the upper quartile.
makeBoxplot(data_median_centered, ...
    resultRankedCellData_level2node1(1, col_start:end), ...
    'Samples', 'log_2 normalized median centered expression');

display_range = 6; 

% Create the labelled clustergram
% Create the hierarchical clustering with the heatmap
cg = clustergram(data_median_centered, ...
    'ColumnLabels',resultRankedCellData_level2node1(1,col_start:end),...
    'RowLabels',resultRankedCellData_level2node1(row_start:end,1),...
    'RowPDist', 'euclidean',... %Select the distance metric for row clustering. 
    'ColumnPDist', 'spearman', ... %Select the distance metric for column clustering. 
    'Linkage','complete',... % Select the linkage method for generating clusters
    'Colormap', custom_colorMap_RedBlue,...
    'DisplayRange', display_range, ... %adjust to data
    'DisplayRatio', 0.1,...
    'LabelsWithMarkers', true);

% OPTION a: color labels for one category, e.g. pathological type
colors = [0.96 0.26 0.44 % pink, INET
         0.26 0.74 0.96]; % blue, AppNET

color_labels = clustergramLabel(resultRankedCellData_level2node1(1,col_start:end),category_labels,colors);
set(cg, 'ColumnLabelsColor', color_labels);

% t-SNE
% Optional: generate tSNE with log2 transformed data
tSNE_data=tsne(transform_data.'); % If plotting with un-transformed data, use numeric_data instead of transform_data

% Plot the t-SNE reduction in data dimensionality
figure; gscatter(tSNE_data(:,1),tSNE_data(:,2),category_labels',colors,[],25);

%% Feature selection for INET vs AppNET (level 2 node 1 and node 2)
% Row number for class labels 
category_row = 3;

% class labels
category_labels = subset_level2node2(category_row,col_start:end);

% feature selection
[idx,scores] = fscchi2(cell2mat(subset_level2node2(row_start:end,col_start:end))',category_labels);

% Plot predictor importance scores
bar(scores(idx))
xlabel('Predictor rank')
ylabel('Predictor importance score')

% Indices of top X selected featues
idx = idx(1:3)+row_start-1;

% Expression data for selected features
resultRankedCellData_level2node2 = subset_level2node2([1:row_start-1 idx],:); 
selectedFeatures_level2node2 = subset_level2node2(idx,1);

% Prepare the data for plotting  
% Extract numeric data only 
numeric_data = cell2mat(resultRankedCellData_level2node2(row_start:end, col_start:end));
% Optional - log2 transform 
transform_data = log2(replaceZeros(numeric_data,'lowval'));
% Median center the data 
data_median_centered = transform_data - median(transform_data, 'all');

% Select display range through boxplot assessment, display range can be any 
% number between the upper range and the upper quartile
makeBoxplot(data_median_centered, ...
    resultRankedCellData_level2node2(1, col_start:end), ...
    'samples', 'log_2 normalized median centered expression');

display_range = 8; 

% Create the labelled clustergram
% Create the hierarchical clustering with the heatmap
cg = clustergram(data_median_centered, ...
    'ColumnLabels',resultRankedCellData_level2node2(1,col_start:end),...
    'RowLabels',resultRankedCellData_level2node2(row_start:end,1),...
    'RowPDist', 'spearman',... %Select the distance metric for row clustering. 
    'ColumnPDist', 'spearman', ... %Select the distance metric for column clustering. 
    'Linkage','complete',... % Select the linkage method for generating clusters
    'Colormap', custom_colorMap_RedBlue,...
    'DisplayRange', display_range, ... %adjust to data
    'DisplayRatio', 0.1,...
    'LabelsWithMarkers', true);

% OPTION a:color labels for one category, e.g. pathological type
colors = [0.96 0.26 0.44 % pink, INET
         0.26 0.74 0.96]; % blue, AppNET

color_labels = clustergramLabel(resultRankedCellData_level2node2(1,col_start:end),category_labels,colors);
set(cg, 'ColumnLabelsColor', color_labels);

% t-SNE
% Optional: generate tSNE with log2 transformed data
tSNE_data=tsne(transform_data.'); % If plotting with un-transformed data, use numeric_data instead of transform_data

% Plot the t-SNE reduction in data dimensionality
figure; gscatter(tSNE_data(:,1),tSNE_data(:,2),category_labels',colors,[],25);

