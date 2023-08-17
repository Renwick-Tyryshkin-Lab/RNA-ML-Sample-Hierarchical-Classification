function [outliers, outliers_IDs, low_outliers, high_outliers] = scatterplotMarkOutliers(data, options)
% SCATTERPLOT_MARK_OUTLIERS(data) makes scatter plot of data, plots horizontal line at the upper and lower
% outlier boundries defined as :
%    25th/75th percentile +/- Alpha x IQR. 
%    see <a href="matlab:web('https://doi.org/10.1080/01621459.1987.10478551')">Hoaglin and Iglewicz (1986)</a>
% Marks outliers and returns logical vectors with outlier cols as 'true'
%
% Syntax:
%   [outliers, low_outliers, high_outliers] = SCATTERPLOT_MARK_OUTLIERS(data[, options])
%
% Inputs:
%   data: 1xN numerical matrix
% Options
%   sampleLabels: cell array of strings; must be same dimenstions as data
%   PlotTitle: string
%   xlabel: string
%   ylabel: string
%   Batch: numeric array
%   
% output:
%   [outliers, outliers_IDs, low_outliers, high_outliers]: all logical arrays indicating
%       all outliers, outliers below the lower threshold, 
%       and outliers above the upper threshold, respectively. 
% usage:
%     data = [1 2 3 4 5 -20 20];     
%     samples = {'sample1' 'sample2' 'sample3' 'sample4' 'sample5' 'sample6' 'sample7'};
%     [outliers, outliers_IDs,high_outliers, low_outliers] = scatterplot_mark_outliers(data, ...
%         'ColumnLabels', samples, ...
%         'PlotTitle', 'Test plot', ...
%         'xlabel', 'placebolder x label',...    
%         'ylabel', 'placeholder y label'); 

% Author: Kathrin Tyryshkin
% Last edited: 27 September 2020 by Justin Wong

%check input arguments
arguments
    data (1,:) {mustBeNumeric}
    options.ColumnLabels = {}
    options.PlotTitle string = ''
    options.xlabel string = ''
    options.ylabel string = ''
    options.Batch (1,:) double = []
    options.ShowXTicks = false;
    options.ShowXTickLabel = true;
end

%compute alpha for outlier detection based on the data size (number of
%samples)
alpha = computeAlphaOutliers(length(data));

% Identify low outler boundaries
qlower = quantile(data, 0.25) - alpha * iqr(data);
low_outliers = data < qlower;

% Identify high outler boundaries
qhigher = quantile(data, 0.75) + alpha * iqr(data);
high_outliers = data > qhigher;

% Plot data
figure, hold on
x = 1:length(data);
%for our purpose, only the low outliers are marked on the plot 
outliers = low_outliers; 
s = plot(x, data, 'b.', 'markersize', 15);
% Plot outlier boundaries
plot([0 length(data)+1], [qlower qlower], '-r', 'linewidth', 2);

if any(outliers)
    % Mark and label outliers
    v = plot(x(outliers), data(outliers), '*m', 'markersize', 15);
    row = dataTipTextRow('Sample ID:',options.ColumnLabels(outliers));
    v.DataTipTemplate.DataTipRows(end+1) = row;
end
if ~isempty(options.ColumnLabels)
    text(x(outliers)+0.3, data(outliers), options.ColumnLabels(outliers),'Interpreter','none');
    row = dataTipTextRow('Sample ID:',options.ColumnLabels);
    s.DataTipTemplate.set('Interpreter','none')
    s.DataTipTemplate.DataTipRows(end+1) = row;
%     dtt = s.DataTipTemplate; 
%     set(dtt,'Interpreter',none)
end

% IDs of samples marked as outliers
outliers_IDs = x(outliers);
if ~isempty(options.ColumnLabels)
    outliers_IDs = options.ColumnLabels(outliers);
end

% Plot aesthetics
% Remove x-ticks if ShowXTicks set to false (default)
if ~options.ShowXTicks
    ax = gca;
    ax.XAxis.TickLength = [0 0];
end

if ~isempty(options.PlotTitle)
    title(options.PlotTitle, 'FontSize',16, 'FontName', 'Helvetica','Interpreter','none');
end

%add sample labels (x axis) if provided, and selected to be shown
if ~isempty(options.ColumnLabels) && options.ShowXTickLabel
    set(gca, 'XTick', 1:length(options.ColumnLabels));
    set(gca, 'XTickLabel', options.ColumnLabels);
    ax = gca;
    ax.XTickLabelRotation = 90;
    ax.TickLabelInterpreter = 'none';
end

%add x axis label if provided
if ~isempty(options.xlabel)
    xlabel(options.xlabel, 'FontSize',14, 'FontName', 'Helvetica','Interpreter','none');
end

%add y axis label if provided
if ~isempty(options.ylabel)
    ylabel(options.ylabel, 'FontSize',14, 'FontName', 'Helvetica','Interpreter','none');
end
%add lines for the batches, if provided
if ~isempty(options.Batch)
    batch_idx = generateBatchIdx(options.Batch);
    for i=1:length(batch_idx)
        xline(batch_idx(i),'--k');
    end
    row2 = dataTipTextRow('Batch ID:',options.Batch);
    s.DataTipTemplate.DataTipRows(end+1) = row2;
    if any(outliers)
        % Mark and label outliers
        row2 = dataTipTextRow('Batch ID:',options.Batch(outliers));
        v.DataTipTemplate.DataTipRows(end+1) = row2;
    end
end

hold off;

end 