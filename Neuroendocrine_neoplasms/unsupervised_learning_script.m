%% Load data 
% OPTIONAL: if starting from Stage 3 or if no longer have final_filt_data in workspace,
% load the data: 
load Stage1_workspace.mat

% Convert to numeric data 
numeric_data = cell2mat(final_filt_data(row_start:end, col_start:end));

%% Unsupervised hierarchical clustering with heatmap
% Prepare the data for plotting  

% OPTIONAL: Replace zeros and log2 transform
transform_data = log2(replaceZeros(numeric_data,'lowval'));

% Median center the data 
data_median_centered = transform_data - median(transform_data, 'all');

% Select display range through boxplot assessment, display range can be any 
% number between the upper range and the upper quartile
makeBoxplot(data_median_centered, ...
    final_filt_data(1, col_start:end), 'Samples', 'log_2 normalized median centered expression');

display_range = 5; 

% Create the hierarchical clustering with the heatmap
cg = clustergram(data_median_centered, ...
    'ColumnLabels', final_filt_data(1,col_start:end),...
    'RowLabels', final_filt_data(row_start:end, 1), ...
    'RowPDist', 'euclidean',... %Select the distance metric for row clustering. 
    'ColumnPDist', 'spearman', ... %Select the distance metric for column clustering. 
    'Colormap', custom_colorMap_RedBlue,...
    'DisplayRange', display_range, ... 
    'DisplayRatio', 0.1);

% Add the color labels through either option a. or b. 

% OPTION a. Only one labelling group. 
% Create clustergram with labels option ('LabelsWithMarkers') set to true
cg_a = clustergram(data_median_centered, ...
    'ColumnLabels', final_filt_data(1,col_start:end),...
    'RowLabels', final_filt_data(row_start:end, 1), ...
    'RowPDist', 'euclidean',... 
    'ColumnPDist', 'spearman', ... 
    'Colormap', custom_colorMap_RedBlue,...
    'DisplayRange', display_range,... 
    'DisplayRatio', 0.1,...
    'LabelsWithMarkers', true);

% Choose the colors for Epithelial vs. Non-epithelial sample types
category_row = 3; % Class labels stored in row 3 of final_filt_data
colors =[1,0,0.5; 0.43,0.71,1]; % pink, light blue
color_labels = clustergramLabel(final_filt_data(1,col_start:end),final_filt_data(category_row,col_start:end),colors); % Generate structure variable for color labels
set(cg_a, 'ColumnLabelsColor', color_labels); % Update clustergram object with color labels

% OPTION b.	More than one labelling category
% Create clustergram with labels option ('LabelsWithMarkers') set to true
cg_b = clustergram(data_median_centered, ...
    'ColumnLabels', final_filt_data(1,col_start:end),...
    'RowLabels', final_filt_data(row_start:end, 1), ...
    'RowPDist', 'euclidean',... 
    'ColumnPDist', 'spearman', ... 
    'Colormap', custom_colorMap_RedBlue,...
    'DisplayRange', display_range, ... 
    'DisplayRatio', 0.1,...
    'LabelsWithMarkers', true);

color_labels = struct(); % Create structure variable to store color labels information

category_row1 = 3; % first category of class labels - epithelial type stored in row 3
category_row2 = 4;  % second category of class labels - pathological type stored in row 4

% Information for first category of class labels, epithelial type
color_labels.label1.labels = final_filt_data(category_row1,col_start:end);
color_labels.label1.colors = [0.7 0 0.5; 0 0.2 0.7];
color_labels.label1.ordered_lbls = unique(final_filt_data(category_row1,col_start:end));
color_labels.label1.description = {'Epithelial Type'};

% Information for second category of class labels, pathological type
color_labels.label2.labels = final_filt_data(category_row2,col_start:end);
% Optionally - You can generate random colors 
color_labels.label2.ordered_lbls = unique(final_filt_data(category_row2,col_start:end));
rand_color = [rand(1,length(color_labels.label2.ordered_lbls));...
    rand(1,length(color_labels.label2.ordered_lbls));...
    rand(1,length(color_labels.label2.ordered_lbls))]'; 
color_labels.label2.colors = rand_color;
color_labels.label2.description = {'Pathological Type'};

% Update clustergram with class labels from multiple categories
modifyClustergram(cg_b, color_labels, 'ischangepossize', true, 'columnLabels', ...
    final_filt_data(1,col_start:end), 'textfont', 14, 'maxrowsOfLbls', 8);
%% t-Distributed Stochastic Neighbour Embedding (t-SNE) 
% Calculate the t-SNE embeddings
tSNE_data = tsne(numeric_data');

% display based on Epithelial type
category_row = 3; % epithelial type stored in row 3 of final_filt_data
colors=[1 0 0.5;0.43 0.71 1]; % pink, light blue

% Visualize the t-SNE two-dimensional embedding 
figure; gscatter(tSNE_data(:,1),tSNE_data(:,2),final_filt_data(category_row, col_start:end)',colors,[],25);

% display based on Pathological type
category_row = 4; % ppithelial type stored in row 4 of final_filt_data

% Plot the t-SNE reduction in data dimensionality
figure; gscatter(tSNE_data(:,1),tSNE_data(:,2),final_filt_data(category_row, col_start:end)',[],[],25);
