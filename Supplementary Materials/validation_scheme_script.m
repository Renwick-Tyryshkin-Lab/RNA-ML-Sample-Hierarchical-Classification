%% Determining hierarchical structure
load Stage1_workspace.mat

% Indicate row for category to use to extract samples 
category_row = 4;

% Only keeping the GI-NET samples - INET, AppNET, PanNET, RNET
ind = contains(final_filt_data(category_row,:),{'INET','AppNET','PanNET', 'RNET'});

ind(1:col_start-1) = true; % first column with feature names
final_filt_data = final_filt_data(:,ind); % Extract GI-NET samples from final_filt_data

%% Make clustergram
% Prepare the data for plotting  
% Convert to numeric data
numeric_data = cell2mat(final_filt_data(row_start:end, col_start:end));
% OPTIONAL: Replace zeros and log2 transform 
transform_data = log2(replaceZeros(numeric_data,'lowval'));
% Median center the data 
data_median_centered = transform_data - median(transform_data, 'all');

% Select display range through boxplot assessment, display range can be any 
% number between the upper range and the upper quartile
makeBoxplot(data_median_centered, ...
    final_filt_data(1, col_start:end), ...
    'Samples', 'log_2 normalized median centered expression');

display_range = 5; 

% Create the labelled clustergram
% Create the hierarchical clustering with the heatmap
cg = clustergram(data_median_centered, ...
    'ColumnLabels',final_filt_data(1,col_start:end),...
    'RowLabels',final_filt_data(row_start:end,1),...
    'RowPDist', 'euclidean',... %Select the distance metric for row clustering. 
    'ColumnPDist', 'spearman', ... %Select the distance metric for column clustering. 
    'Linkage','complete',... % Select the linkage method for generating clusters
    'Colormap', custom_colorMap_RedBlue,...
    'DisplayRange', display_range, ... %adjust to data
    'DisplayRatio', 0.1,...
    'LabelsWithMarkers', true);

% OPTION a: one color label
% Choose the colors for Pathological types
category_row = 4; % pathological type stored in row 4 of final_filt_data
colors = [0.83 0.14 0.14 % red, PanNET
         1.00 0.54 0.00 % orange, INET
         0.47 0.25 0.80 % purple, AppNET
         0.25 0.80 0.54]; % green, RNET

% Add the coloring labels to the clustergram
color_labels = clustergramLabel(final_filt_data(1,col_start:end),final_filt_data(category_row,col_start:end),colors); % Create structure with color labels information
set(cg, 'ColumnLabelsColor', color_labels); % Update clustergram with color labels

%% t-SNE
% Optional: generate tSNE with log2 transformed data
tSNE_data = tsne(transform_data.'); % If plotting with un-transformed data, use numeric_data instead of transform_data

% Plot the t-SNE reduction in data dimensionality
figure; gscatter(tSNE_data(:,1),tSNE_data(:,2),final_filt_data(category_row,col_start:end)',colors,[],25);

%% Add labels based on embryological origin
category_row = 4; % Pathological type stored in row 4 of final_filt_data

% Create labels based on embryological origin of the pathological types
label1 = cell(1,size(final_filt_data,2)); % Create cell array same size as the number of samples + any additional columns
label1(1)= {'Embryological_Origin'};
label1(col_start:end) = {'ND'}; % Assign 'ND' value for all samples

% Mark Ileal and Appendiceal samples as  'Midgut'
ind = ismember(final_filt_data(category_row,:),{'INET','AppNET'});
label1(ind) = {'Midgut'}; 

% Mark Rectal and Pancreatic samples as 'Non-midgut'
ind = ismember(final_filt_data(category_row,:),{'RNET','PanNET'});
label1(ind) = {'Non-midgut'}; 

% Check there are no 'ND' values in label 1
checkLabel(label1,final_filt_data(category_row,:),'ND')
%% Separate data based on embryological origin classification
% Midgut: INET vs AppNET - only midgut samples
ind_node = strcmp(label1(:,col_start:end),'Midgut');
subset_level2node1 = final_filt_data(:,[true([1 col_start-1]) ind_node]);

% Non-midgut: PanNET vs RNET - only non-midgut samples
ind_node = strcmp(label1(:,col_start:end),'Non-midgut');
subset_level2node2 = final_filt_data(:,[true([1 col_start-1]) ind_node]);

%% Visualizations for Midgut: INET vs AppNET
% Prepare the data for plotting  
% Extract numeric data only 
numeric_data = cell2mat(subset_level2node1(row_start:end, col_start:end));
% OPTIONAL: log2 transform 
transform_data = log2(replaceZeros(numeric_data,'lowval'));
% Median center the data 
data_median_centered = transform_data - median(transform_data, 'all');

% Select display range through boxplot assessment, display range can be any 
% number between the upper range and the upper quartile
makeBoxplot(data_median_centered, ...
    subset_level2node1(1, col_start:end), ...
    'Samples', 'log_2 normalized median centered expression');

display_range = 4; 

% Create the labelled clustergram
% Create the hierarchical clustering with the heatmap
cg = clustergram(data_median_centered, ...
    'ColumnLabels',subset_level2node1(1,col_start:end),...
    'RowLabels',subset_level2node1(row_start:end,1),...
    'RowPDist', 'euclidean',... %Select the distance metric for row clustering. 
    'ColumnPDist', 'spearman', ... %Select the distance metric for column clustering. 
    'Linkage','complete',... % Select the linkage method for generating clusters
    'Colormap', custom_colorMap_RedBlue,...
    'DisplayRange', display_range, ... %adjust to data
    'DisplayRatio', 0.1,...
    'LabelsWithMarkers', true);

% OPTION a: one color label
% Choose the colors for only midgut Pathological types
category_row = 4; 
colors = [1.00 0.54 0.00 % orange, INET
         0.47 0.25 0.80]; % purple, AppNET

color_labels = clustergramLabel(subset_level2node1(1,col_start:end),subset_level2node1(category_row, col_start:end),colors); % Structure with color label information
set(cg, 'ColumnLabelsColor', color_labels); % Update clustergram with color labels

% t-SNE
% Optional: generate tSNE with log2 transformed data
tSNE_data=tsne(transform_data.'); % If plotting with un-transformed data, use numeric_data instead of transform_data

% Plot the t-SNE reduction in data dimensionality
figure; gscatter(tSNE_data(:,1),tSNE_data(:,2),subset_level2node1(category_row, col_start:end)',colors,[],25);

%% Visualizations for Level 1 Node 2 (Non-midgut; RNET vs PanNET)
% Prepare the data for plotting  
% Convert to a numeric data table
numeric_data = cell2mat(subset_level2node2(row_start:end, col_start:end));
% OPTIONAL: log2 transform 
transform_data = log2(replaceZeros(numeric_data,'lowval'));
% Median center the data 
data_median_centered = transform_data - median(transform_data, 'all');

% Select display range through boxplot assessment, display range can be any 
% number between the upper range and the upper quartile
makeBoxplot(data_median_centered, ...
    subset_level2node2(1, col_start:end), ...
    'Samples', 'log_2 normalized median centered expression');

display_range = 4; 

% Create the labelled clustergram
% Create the hierarchical clustering with the heatmap
cg = clustergram(data_median_centered, ...
    'ColumnLabels',subset_level2node2(1,col_start:end),...
    'RowLabels',subset_level2node2(row_start:end,1),...
    'RowPDist', 'euclidean',... %Select the distance metric for row clustering. 
    'ColumnPDist', 'spearman', ... %Select the distance metric for column clustering. 
    'Linkage','complete',... % Select the linkage method for generating clusters
    'Colormap', custom_colorMap_RedBlue,...
    'DisplayRange', display_range, ... %adjust to data
    'DisplayRatio', 0.1,...
    'LabelsWithMarkers', true);

% OPTION a: one color label
% Choose the colors for only midgut Pathological types
category_row = 4; 

colors = [0.83 0.14 0.14 % red, PanNET
          0.25 0.80 0.54]; % green, RNET

color_labels = clustergramLabel(subset_level2node2(1,col_start:end),subset_level2node2(category_row, col_start:end),colors); % Structure with color label information
set(cg, 'ColumnLabelsColor', color_labels); % Update clustergram with color labels

% t-SNE
% Optional: generate tSNE with log2 transformed data
tSNE_data=tsne(transform_data.'); % If plotting with un-transformed data, use numeric_data instead of transform_data

% Plot the t-SNE reduction in data dimensionality
figure; gscatter(tSNE_data(:,1),tSNE_data(:,2),subset_level2node2(category_row, col_start:end)',colors,[],25);

% Label for level 2 of the hierarchy
label2 = final_filt_data(category_row,:);
%% Reformatted with labels and expression data 
% Concatenate all labels for hierarchy into one
labels = [label1;label2];

% Header rows to keep from final_filt_data, row 1 is sample IDs
rows_to_keep = final_filt_data([1],:); 

% Any header rows + labels + expression data (with header columns)
data_labelled = [rows_to_keep;labels;final_filt_data(row_start:end,:)];

%% Prepare data for cross-validation and feature selection 
groupingVar_row = data_labelled(2,col_start:end); 

% Use hold-out validation with 30% reserved for validation
split_data = cvpartition(groupingVar_row,'HoldOut',0.3);

% Retrieve training and validation data from original
training_data = data_labelled(:,[true(1:col_start-1); training(split_data)]);
validation_data = data_labelled(:,[true(1:col_start-1); test(split_data)]);

%% Output the datasets
clearvars -except training_data validation_data 
save (fullfile('results_data','trainingValidation_data.mat'), 'training_data', 'validation_data');
writecell(training_data,fullfile('results_data','training_data4MFeaST.csv'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Selecting top ranking features 
% Save all ranked results as .mat file from MFeaST under results_data
% folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Create subset of data for selected features 
% Row and column where numeric expression data starts in training_data and validation_data
row_start = 4; 
col_start = 2; 

% Load and assign selected features from MFeaST results
load('midgut_v_nonmidgut_rankedResults.mat', 'resultRankedCellData');
resultRankedCellData_level1node1 = resultRankedCellData; 
selectedFeatures_level1node1 = {'hsa-miR-615(1)','hsa-miR-92b(1)'}; 
  
load('INET_v_AppNET_rankedResults.mat','resultRankedCellData');
selectedFeatures_level2node1 = {'hsa-miR-192(1)','hsa-miR-125b(2)','hsa-miR-149(1)'};
resultRankedCellData_level2node1 = resultRankedCellData;

load ('PanNET_v_RNET_rankedResults.mat','resultRankedCellData');
selectedFeatures_level2node2 = {'hsa-miR-487b(1)','hsa-miR-429(1)'};
resultRankedCellData_level2node2 = resultRankedCellData;

% Save selected features and overall ranked results for each node of
% decision structure
save (fullfile('project_data','Stage3_featureSelection.mat'), 'selectedFeatures_level1node1', 'selectedFeatures_level2node1', 'selectedFeatures_level2node2', 'col_start', 'row_start','validation_data','training_data')
save (fullfile('project_data','rankedResults.mat'), 'resultRankedCellData_level1node1', 'resultRankedCellData_level2node1', 'resultRankedCellData_level2node2')