function evalTable = evaluationMetrics(cm,order,type)
% This function calculates several evaluation metrics which may be useful
% when assessing the performance of a classifier.
% INPUTS: 
% cm - confusion matrix
% order - order of class labels in confusion matrix
% type - method for combining the metrics for each class into an overall
%        performance metrics: micro - sum the confusion matrix terms first
%        and calculate global metrics, macro - take average of metrics for
%        each class, weighted - take weighted average of metrics for each
%        layer
% OUTPUTS:
% evalTable - table with combined metrics for each class in cm and order,
%             and last row for overall performance
% Written by: Tashifa Imtiaz 26 July 2022

arguments
    cm (:,:) {mustBeNumeric,mustBeSquare(cm)}
    order (1,:) {mustBeVector} = [];
    type string {mustBeMember(type,["micro","macro","weighted"])} = "macro";
end
if isempty(order)
    order = strsplit(num2str(1:size(cm,1)))'; 
end
if size(order,2)>size(order,1)
    order = order';
end

confusionchart(cm,order)

tp = zeros(size(order));
fp = zeros(size(order));
tn = zeros(size(order));
fn = zeros(size(order));

% Calculate true positives, false positives, false negatives, true
% negatives by summation across classes
for n = 1:size(cm,1)
    tp(n) = cm(n,n);
    fp(n) = sum(cm(:,n),'all') - tp(n);
    fn(n) = sum(cm(n,:),'all') - tp(n); 
    tn(n) = sum(cm,'all') - tp(n) - fp(n) - fn(n);
end

% Precision (positive predictive value)
precisionScore = tp./(tp+fp);
% Negative Predictive Value
npv = tn./(fn+tn);
% Recall
recallScore = tp./(tp+fn);
% Sensitivity (recall, true positive rate)
sensitivityScore = 100.*recallScore;
% Specificity (true negative rate)
specificityScore = 100.*tn./(fp+tn);
% False positive rate 
fpr = 1 - recallScore; 
% F1 score
f1Score = 2.*(precisionScore.*recallScore)./(precisionScore+recallScore);
% MCC score
mccScore = (tp.*tn-fp.*fn)./sqrt((tp+fp).*(tp+fn).*(tn+fp).*(tn+fn));
% Accuracy 
acc = (tp+tn)./(tp + tn + fn + fp);

% Create a table for results
evalTable = [precisionScore npv recallScore sensitivityScore...
     specificityScore fpr f1Score mccScore acc];
varNames = {'Precision','Negative Predictive Value','Recall', 'Sensitivity',...
    'Specificity','False Predictive Rate','F1 Score','MCC', 'Accuracy'};
evalTable = array2table(evalTable,"RowNames",order,"VariableNames",varNames);

switch type
    case "micro"
        tp = sum(tp); fp = sum(fp); tn = sum(tn); fn = sum(fn);
        precisionOverall = tp/(tp+fp);
        % Negative Predictive Value
        npvOverall = tn./(fn+tn);
        % Recall
        recallOverall = tp./(tp+fn);
        % Sensitivity (recall, true positive rate)
        sensitivityOverall = 100.*recallOverall;
        % Specificity (true negative rate)
        specificityOverall = 100.*tn./(fp+tn);
        % False positive rate 
        fprOverall = 1 - recallOverall; 
        % F1 score
        f1Overall = 2.*(precisionOverall.*recallOverall)./(precisionOverall+recallOverall);
        % MCC score
        mccOverall = (tp.*tn-fp.*fn)./sqrt((tp+fp).*(tp+fn).*(tn+fp).*(tn+fn));
        % Accuracy 
        accOverall = (tp+tn)./(tp + tn + fn + fp);

    case "macro"
        precisionOverall = mean(precisionScore,'omitnan');  
        % Negative Predictive Value
        npvOverall = mean(npv,'omitnan');
        % Recall
        recallOverall = mean(recallScore,'omitnan');
        % Sensitivity (recall, true positive rate)
        sensitivityOverall = mean(sensitivityScore,'omitnan');
        % Specificity (true negative rate)
        specificityOverall = mean(specificityScore,'omitnan');
        % False positive rate 
        fprOverall = mean(fpr,'omitnan'); 
        % F1 score
        f1Overall = mean(f1Score,'omitnan');
        % MCC score
        mccOverall = mean(mccScore,'omitnan');
        % Accuracy 
        accOverall = mean(acc,'omitnan');

    case "weighted"
        precisionOverall = sum(precisionScore.*sum(cm,2),'omitnan')/sum(cm,'all','omitnan');
        npvOverall = sum(npv.*sum(cm,2),'omitnan')/sum(cm,'all','omitnan');
        % Recall
        recallOverall = sum(recallScore.*sum(cm,2),'omitnan')/sum(cm,'all','omitnan');
        % Sensitivity (recall, true positive rate)
        sensitivityOverall = sum(sensitivityScore.*sum(cm,2),'omitnan')/sum(cm,'all','omitnan');
        % Specificity (true negative rate)
        specificityOverall = sum(specificityScore.*sum(cm,2),'omitnan')/sum(cm,'all','omitnan');
        % False positive rate 
        fprOverall = sum(fpr.*sum(cm,2),'omitnan')/sum(cm,'all','omitnan');
        % F1 score
        f1Overall = sum(f1Score.*sum(cm,2),'omitnan')/sum(cm,'all','omitnan');
        % MCC score
        mccOverall = sum(mccScore.*sum(cm,2),'omitnan')/sum(cm,'all','omitnan');
        % Accuracy 
        accOverall = sum(acc.*sum(cm,2),'omitnan')/sum(cm,'all','omitnan');
end

evalTable = [evalTable;array2table([precisionOverall npvOverall recallOverall sensitivityOverall...
     specificityOverall fprOverall f1Overall mccOverall accOverall],'RowNames',{'Overall'},'VariableNames',varNames)];
end

function mustBeSquare(x)
if diff(size(x))
    eidType = 'mustBeSquare:notSquare';
    msgType = 'The first input must be a square confusion matrix of dimensions nxn.';
    throwAsCaller(MException(eidType,msgType))
end
end
