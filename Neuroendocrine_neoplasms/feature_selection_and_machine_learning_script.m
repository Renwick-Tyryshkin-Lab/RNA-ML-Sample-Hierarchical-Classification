%% Assess selected features using the MATLAB Classification Learner App

% Load the workspace variable created in Stage 3
load Stage3_featureSelection.mat

%% Prepare data for Classification Learner App 
% Repeat for all levels and nodes of the hierarchy determined
subset_level1node1 = createSubset(training_data,row_start-1, selectedFeatures_level1node1);

% Midgut: INET vs AppNET - only midgut samples
category_row = 2; % Row 2 contains embryological origin class in training_data

% Extract midgut samples from training_data with selected features
ind_col = strcmp(training_data(category_row,col_start:end),'Midgut');
subset_level2node1 = training_data(:,[true([1 col_start-1]) ind_col]);
subset_level2node1 = createSubset(subset_level2node1,row_start-1, selectedFeatures_level2node1);

% Non-midgut: PanNET vs RNET - only non-midgut samples
category_row = 2; % Row 2 contains embryological origin class in training_data

% Extract non-midgut samples from training_data with selected features
ind_col = strcmp(training_data(category_row,col_start:end),'Non-midgut');
subset_level2node2 = training_data(:,[true([1 col_start-1]) ind_col]);
subset_level2node2 = createSubset(subset_level2node2,row_start-1, selectedFeatures_level2node2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Training in Classification Learner App 
% Open Classification Learner app and train models for each level and node
%% Save the trained model in a workspace variable 
save (fullfile('results_data','trainedModels.mat'), 'trainedModel_level1node1',...
    'trainedModel_level2node1', 'trainedModel_level2node2');  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load training data, validation data, and classifier models
load trainingValidation_data.mat 
load trainedModels.mat 

% -------------------------------------------------------------------------
%% Training performance of hierarchical classifier (FOR INTERNAL USE ONLY)
% Prepare data for predictions
data2classify_level1node1=createSubset(training_data,row_start-1, trainedModel_level1node1.RequiredVariables);
%% Predict midgut or non-midgut
% Make predictions at level 1 node 1 on training data
predictions_level1node1 = trainedModel_level1node1.predictFcn(data2classify_level1node1);

% Create confusion matrix 
[cm_level1node1,order_level1node1] = confusionmat(data2classify_level1node1.Embryological_Origin,predictions_level1node1);
figure;confusionchart(cm_level1node1,order_level1node1)

%% Predict AppNET vs INET
% Extract predicted midgut samples with selected features for level 2 node 1
ind_col = strcmp(predictions_level1node1,'Midgut')';
data2classify_level2node1 = training_data(:,[true([1 col_start-1]) ind_col]);
data2classify_level2node1 = createSubset(data2classify_level2node1,row_start-1, trainedModel_level2node1.RequiredVariables);

% Make predictions on midgut samples (assigned in level 1 node 1)
predictions_level2node1 = trainedModel_level2node1.predictFcn(data2classify_level2node1);

% Create confusion matrix 
[cm_level2node1,order_level2node1] = confusionmat(data2classify_level2node1.Pathological_type,predictions_level2node1);
figure;confusionchart(cm_level2node1,order_level2node1)

%% Predict PanNET vs RNET
% Extract predicted non-midgut samples with selected features for level 2 node 2
ind_col = strcmp(predictions_level1node1,'Non-midgut')';
data2classify_level2node2 = training_data(:,[true([1 col_start-1]) ind_col]);
data2classify_level2node2 = createSubset(data2classify_level2node2,row_start-1, trainedModel_level2node2.RequiredVariables);

% Make predictions on non-midgut samples (assigned in level 1 node 1)
predictions_level2node2=trainedModel_level2node2.predictFcn(data2classify_level2node2);

% Create confusion matrix
[cm_level2node2,order_level2node2] = confusionmat(data2classify_level2node2.Pathological_type,predictions_level2node2);
figure;confusionchart(cm_level2node2,order_level2node2)

%% Results Summary
% Confusion matrix for all training results
predicted_overall = [predictions_level2node1;predictions_level2node2];
expected_overall = [data2classify_level2node1.Pathological_type;data2classify_level2node2.Pathological_type];
[cm_overall, order_overall] = confusionmat (expected_overall,predicted_overall);

% Create a summarized results table
figure; training_results = evaluationMetrics(cm_overall,order_overall,'macro');

% -------------------------------------------------------------------------
%% Validation of hierarchical classifier 
% Prepare data for predictions
data2classify_level1node1=createSubset(validation_data,row_start-1, trainedModel_level1node1.RequiredVariables);

%% Predict midgut or non-midgut
% Make predictions for level 1 node 1 on validation data
predictions_level1node1=trainedModel_level1node1.predictFcn(data2classify_level1node1);

% Create confusion matrix 
[cm_level1node1,order_level1node1] = confusionmat(data2classify_level1node1.Embryological_Origin,predictions_level1node1);
figure; confusionchart(cm_level1node1,order_level1node1)

%% Predict AppNET vs INET
% Extract predicted midgut samples with selected features for level 2 node 1
ind_col = strcmp(predictions_level1node1,'Midgut')';
data2classify_level2node1 = validation_data(:,[true([1 col_start-1]) ind_col]);
data2classify_level2node1 = createSubset(data2classify_level2node1,row_start-1, trainedModel_level2node1.RequiredVariables);

% Make predictions on midgut samples (assigned in level 1 node 1)
predictions_level2node1=trainedModel_level2node1.predictFcn(data2classify_level2node1);

% Create confusion matrix 
[cm_level2node1,order_level2node1] = confusionmat(data2classify_level2node1.Pathological_type,predictions_level2node1);
figure;confusionchart(cm_level2node1,order_level2node1)

%% Predict PanNET vs RNET
% Extract predicted non-midgut samples with selected features for level 2 node 2
ind_col = strcmp(predictions_level1node1,'Non-midgut')';
data2classify_level2node2 = validation_data(:,[true([1 col_start-1]) ind_col]);
data2classify_level2node2 = createSubset(data2classify_level2node2,row_start-1, trainedModel_level2node2.RequiredVariables);

% Make predictions on non-midgut samples (assigned in level 1 node 1)
predictions_level2node2=trainedModel_level2node2.predictFcn(data2classify_level2node2);

% Make confusion matrix
[cm_level2node2,order_level2node2] = confusionmat(data2classify_level2node2.Pathological_type,predictions_level2node2);
figure;confusionchart(cm_level2node2,order_level2node2)

%% Results Summary
% Confusion matrix for all 
predicted_overall = [predictions_level2node1;predictions_level2node2];
expected_overall = [data2classify_level2node1.Pathological_type;data2classify_level2node2.Pathological_type];
[cm_overall, order_overall] = confusionmat (expected_overall,predicted_overall);

% Create a summarized results table
figure; validation_results = evaluationMetrics(cm_overall,order_overall,'macro');

% Save validation performance measures
writetable(validation_results,fullfile('project_data','Table 1.xlsx'),'WriteRowNames',true,'WriteVariableNames',true)
