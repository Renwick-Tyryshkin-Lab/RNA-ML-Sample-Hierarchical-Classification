function s = clustergramLabel(sample_names,labels,color_choices)
% This function creates a colour structure to be inputted into the
% clustegram command to assign colour labels. 
%
% Input:
%   sample_names:      cell array of sample names for each column in data_array
%   labels:            cell array of sample type/group for each column in data_array
%   color_choices:     cell array of RGB triplets, each colour will be used in
%                      order to label sample types
% 
% Output:
%   A structure containing the colors and labels to be passed into the
%   clustergram function for showing color labels. 
%
% Author:           Kathrin Tyryshkin, adapted by Jina Nanayakkara
% Date:             March 2020

%check input arguments
arguments
    sample_names (1,:) cell
    labels (1,:) cell {mustBeEqualSize(sample_names,labels)}
    color_choices (:,3) double {mustBeSameCount(labels,color_choices)}
end

% Make a numeric array that indicates sample type
classes = grp2idx(labels);

%% Set up colour vector
% Create a structure with each sample label and the color it should be
% labelled with based on sample type
s = struct;
s.Labels = sample_names;
colorvec = num2cell(color_choices(classes,:),2);
s.Colors = (colorvec);

end

% Custom validation function
function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'Size of first input must equal size of second input.';
        throwAsCaller(MException(eid,msg))
    end
end
function mustBeSameCount(labels,colors)
    if ~isequal(size(unique(labels),2), size(colors(:,1),1))
        eid = 'Counts:notEqual';
        msg = 'The number of colors must be equal to the number of unique labels.';
        throwAsCaller(MException(eid,msg))
    end
end