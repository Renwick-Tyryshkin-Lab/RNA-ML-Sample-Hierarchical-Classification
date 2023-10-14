function makeBoxplot( data, x_tick_labels, x_label, y_label, batch_idx,opts)
% This function creates a formatted boxplot that is coloured according to
% an input RGB matrix. 
%
% Input:
%   data:             double array of log transformed expression data, where each
%                     column is a sample and each row is a unique molecule (ie. gene or miRNA)         
%   x_tick_labels:    cell array of sample names for each column in data_array
%   x_label:          x-axis label
%   y_label:          y-axis label
%   batch_idx:        index to mark boundaries between batches
%
% Output:
%   A formatted boxplot of miRNA expression distributions
%
% Author:           Justin Wong
% Date:             March 2018
% Updated:          Oct. 2018 by Jina Nanayakkara
% Updated:          Feb. 2020 by Kathrin Tyryshkin


%check input arguments
arguments
    data (:,:) {mustBeNumeric}; 
    x_tick_labels cell {mustBeEqualLength(data, x_tick_labels)};
    x_label string
    y_label string
    batch_idx (1,:) {mustBeNumeric} = [];
    opts.showTickLabels logical {mustBeNumericOrLogical} = true; 
end

if ~isempty(batch_idx)
    % Find locations of batch boundaries on figure
    batch_idx = generateBatchIdx(batch_idx);
end

% Create the boxplot using the input data and colours provided
figure, hold on
boxplot(data,'Colors',[0.6 0.6 0.6],'BoxStyle','outline','Symbol','k','MedianStyle','target','Labels',x_tick_labels);

% Create tick labels on the x-axis
if opts.showTickLabels
    ax = gca;
    set(ax, 'XTickLabel', x_tick_labels);
    ax.XTickLabelRotation=90;
else
    ax = gca;
    set(ax, 'XTickLabel', []);
end
%Mark batches using a dotted line
for i=1:length(batch_idx)
    xline(batch_idx(i),'--k');
end

% Add labels to the x and y axes
xlabel(x_label, 'FontSize', 14, 'FontName', 'Helvetica');
ylabel(y_label, 'FontSize', 14, 'FontName', 'Helvetica');

hold off
end

% Custom validation function
function mustBeEqualLength(a,b)
    % Test if a and b have equal number of columns 
    if ~isequal(size(a(1,:)),size(b))
        error('Number of columns in the data input (first argument) must be the same as number of x labels (second argument)');
    end
end