function modifyClustergram(clust_obj, labels_struct, options)
% %function modifyClustergram adds colorlabels below the heatmap of the
% clustergram. It also adjusts font and position of the heatmap and the
% dendrograms. When user only wants to adjust the font and potiion, without
% adding the color labels, then the labels_struct should be empty.   
%
% Input:
%   clust_obj: the clustergram object to which the modifications are added
%   labels_struct: a struct. It can be empty, the no color labels are
%       added. If it is not empty, it has one field for each row of
%       color labels that are added. Each of these fields must have the
%       following fields:
%           'labels' - a vector/cell array with labels for each sample,
%               labels longer than 15 characters are truncated
%           'ordered_lbls' - a vector/cellarray with unique labels, these
%               should be ordered in the order to be displayed in the legend
%           'colors' - a vector/cell array with a color (3d vector) for
%               each unique label, order corresponding to the ordered_lbls  
%           'description' - a vector/cell array with an optional
%               description for the color label strip. Set as an empty
%               string ('') when no description is required. If description
%               is longer than 30characters, it is truncated.
%           'excl_from_legend' - a vector/cell array with labels from
%               ordered_lbls that should be excluded from the legend
%   options: 
%       textfont - font for the clustergram row and column labels. Default
%           is = 12pnt, mustBeInRange(6,24)
%       img_textfont - font for the color label legends and description.
%           Default is = 9pnt, mustBeInRange(6,11)
%       italicizeRowLabels - italicize row lables of the clustergram (e.g.
%           when these are gene names)
%       dendrlinewidth - Line width for the dendrograms. Default is 2
%       ischangepossize - whether the figure needs resizing, Default =
%           false. Note, resizing after the modifications will change the
%           font of the Row and Column labels. If that is not desired,
%           specify the figure size and set ischangepossize to true. 
%       newpossize  - new figure size, applied if ischangepossize is true.
%           Default = [500 360 550 450] 
%       columnLabels -  a vector/cell array with columnLabels. These MUST
%           be in the order matching the order of the samples in the color
%           label struct (i.e. not necessarily in the order of the
%           labels passed to the clustergram function. If no ColumnLabels
%           were passed to the clustergram function, then there is no need 
%           to specify this parameter   
%       outer_padding - padding on the edge of the figure. Default is .07
%           (7% of the width of the figure) 
%       inner_padding - padding between panels in the figure. Default is .01
%            (1/7 of the outerpadding) 
% Example:
%     rng('default')
%     rowlabels = {'1', '2', '3', 'four', '5', 'the labels is too long and will be cut', '7', '8', '9', '10'};
%     collabels = {'one', 'two', 'three', 'four', 'five', 'six', 'sevens', 'eight', 'nine', 'ten'};
% 
%     cg = clustergram(rand(10,10), 'Cluster', 3, 'DisplayRatio', .1,...
%     'RowLabels', rowlabels,'ColumnLabels',collabels );
%     addTitle(cg, 'Title for the Clustergram (optional)');
%     labels_struct = struct();
%     labels_struct.label1.labels = [ones(5,1); ones(5,1)+1];
%     labels_struct.label1.colors = {.7 0 .5; 0 0.2 .7};
%     labels_struct.label1.ordered_lbls = {'1', '2'};
%     labels_struct.label1.description = {'Group'};
%     labels_struct.label2.labels(1:3) = {'ABC'}; 
%     labels_struct.label2.labels(4:7) = {'GCB'};
%     labels_struct.label2.labels(8:10) = {'LegendIsLongerthan15chars'};
%     labels_struct.label2.ordered_lbls = {'ABC', 'GCB', 'LegendIsLongerthan15chars'};
%     labels_struct.label2.colors = {.7 0 .5; 0 0.2 .7; 0 .5 .5};
%     labels_struct.label2.description = {'This is description for the second label'};
% 
%     modifyClustergram(cg, labels_struct, 'ischangepossize', true, 'columnLabels', collabels);
%     
%example 2: 
%       %not passing columnLabels to the clustergram and to
%       %modifyClustergram functions produces the same result: 
%       cg = clustergram(rand(10,10), 'Cluster', 3, 'DisplayRatio', .1,...
%           'RowLabels', rowlabels);
%       modifyClustergram(cg, labels_struct, 'ischangepossize', true);

% Author: Kathrin Tyryshkin
% Last edited: 3 June 2022
 
 
%input checking                        
    arguments
        clust_obj {mustBeClustergram(clust_obj)}
        labels_struct struct {mustBeValidStruct(labels_struct)} 
        options.textfont uint8 {mustBeGreaterThan(options.textfont, 5), mustBeLessThan(options.textfont, 25)} = 12 
        options.img_textfont uint8 {mustBeGreaterThan(options.img_textfont, 5), mustBeLessThan(options.img_textfont, 12)}= 9 
        options.italicizeRowLabels = false
        options.dendrlinewidth uint8 = 2
        options.ischangepossize logical = false
        options.newpossize(1,4) double = [500 360 550 450]
        options.columnLabels {mustBeValidLabels(options.columnLabels, clust_obj)}= {}
        options.maxrowsOfLbls double {mustBeGreaterThan(options.maxrowsOfLbls, 0)}=5
        options.outer_padding double {mustBeGreaterThanOrEqual(options.outer_padding, 0), mustBeLessThan(options.outer_padding, 1)} = .07 %edge of the figure
        options.inner_padding double {mustBeGreaterThanOrEqual(options.inner_padding, 0), mustBeLessThan(options.inner_padding, 1)} = .01;%1/7 of the outer padding
    end
        
    % Get figure handles that correspond to clustergram objects
    clusterfig = findall(0,'type','figure', 'Tag', 'Clustergram');
    %In case there are more than one clustergram objects, operate on the
    %first one on the list - that will be the last clustergram created.
    currClustergramIdx = 1;     
    if options.ischangepossize  %change size of the clustergram      
        %Set clustergram's new position
        set(clusterfig(currClustergramIdx),'Position', options.newpossize);
    end
    
    %make sure the input columnLabels is a cell array of strings
    options.columnLabels = convertIfNeeded(options.columnLabels);
        
    %calculate the new size/position for all the axes: heatmap, dendrograms
    %and the labels under the clustergram
    numberOfImgLabels = length(fieldnames(labels_struct));  
    %trim labels if too long, convert to text if numeric
    labels_struct = adjustTextLabels(labels_struct);
    %calculate the size needed for the text labels 
    titleAx = findall(clusterfig(currClustergramIdx),'Tag','HeatMapTitleAxes');
    clustergram_props = calcTextSize(titleAx, labels_struct, options.img_textfont,options.maxrowsOfLbls);
    
    
    %% calculate the new height of all axes (panels):  
    %title axis, top axis (the top/column dendrogram), 
    %the middle axis (heatmap, side/row dendrogram and the colorbar
    %the low axis (the color labels with legend and description
    
    %height of the image labels bar is the number of labels*height of the
    %txt legend + number of labels*space between the labels
    clustergram_props.lowPanelHeight = clustergram_props.num_legend_rows*clustergram_props.txt_height;
    clustergram_props.topPanelHeigth = 0;    
    %Find top/column dendrorgram axis 
    dendroAxCol = findall(clusterfig(currClustergramIdx),'Tag','DendroColAxes');
    if ~isempty(dendroAxCol) && ~strcmpi(clust_obj.ShowDendrogram, 'Off')      
        p = get(dendroAxCol, 'Position');
        clustergram_props.topPanelHeigth = p(4);
    end
    %find title if exists
    titleAx = findall(clusterfig(currClustergramIdx),'Tag','HeatMapTitleAxes');
    a = findall(titleAx,'Type','text');
    clustergram_props.titleHeight = 0;
    if ~isempty(get(a, 'string'))
        e = get(a, 'extent');
        clustergram_props.titleHeight = e(4);
    end
    
    clustergram_props.midPanelHeight = max(0, 1-(clustergram_props.lowPanelHeight+options.outer_padding+options.inner_padding)-...
        (clustergram_props.topPanelHeigth) - (clustergram_props.titleHeight+options.outer_padding));
         
    %% calculate the new width of all axes (panels)
    %left panel (the left/row dendrogram with colorbar and the image lbl
    %description; mid axis (the up/col dendrogram, the heatmap, the image
    %labels); right axis (the image legends and the heatmap row labels)
    
    %Find side/row dendrogram axis 
    left_dendro_width = 0;
    dendroAxRow = findall(clusterfig(currClustergramIdx),'Tag','DendroRowAxes');
    if ~isempty(dendroAxRow) && ~strcmpi(clust_obj.ShowDendrogram, 'Off')        
        p = get(dendroAxRow, 'Position');
        left_dendro_width = p(3);
    end
    %assume the color bar takes the same space as the left dendrogram.  
    % Can only find out its true size when it is plotted, but have to plot
    % it after the heatmap is adjusted, so that it matches the height     
    clustergram_props.leftPanelWidth = max(clustergram_props.descr_txtwidth+options.inner_padding, 2*left_dendro_width);
 
    %find the longest clustergram row label, if longer than 15 - truncate
    heatmapAx = findall(clusterfig(currClustergramIdx),'Tag','HeatMapAxes');   
    all_row_labels = get(heatmapAx, 'YTickLabel');
    x = 1:length(all_row_labels);
    x=x(cellfun(@(x) numel(x),all_row_labels)>15);
    for j=1:length(x)
        currstr = all_row_labels{x(j)};
        all_row_labels(x(j)) = {currstr(1:min(end,15))};
%         disp(['Note: row label ' currstr ' is too long, truncating to 15 characters']);
    end
    if options.italicizeRowLabels
       all_row_labels = strcat('\it', all_row_labels);
    end
    set(heatmapAx, 'YTickLabel', all_row_labels);
    val=cellfun(@(x) numel(x), all_row_labels);
    longest_row_str=all_row_labels(val==max(val));
    longest_row_str = cell2mat(longest_row_str(1));
    t = text(titleAx, 0.5,0.5,longest_row_str, 'fontsize', options.textfont);
    e = get(t, 'Extent');
    maxRowLblWidth = e(3);
    delete(t);
    
    %right panel width
    clustergram_props.rightPanelWidth = max(clustergram_props.leg_txtwidth+options.inner_padding, maxRowLblWidth);
        
    clustergram_props.midPanelWidth = max(0, 1-(clustergram_props.rightPanelWidth+...
        options.outer_padding)-(clustergram_props.leftPanelWidth+options.outer_padding));
    
    %% rearrange all existing axes, to fit in image labels, remove white spaces
    %and make sure the colorbar and text labels fit into the figure space
    t = findall( clusterfig(currClustergramIdx), 'type', 'axes');
    for i=1:length(t) %shift every axis
        currPos = get(t(i), 'Position');
        if strcmp(get(t(i), 'tag'), 'DendroRowAxes')
           currPos(1) = clustergram_props.leftPanelWidth-left_dendro_width+options.outer_padding+options.inner_padding;
           currPos(2) = clustergram_props.lowPanelHeight+options.outer_padding+options.inner_padding;
           currPos(4) = clustergram_props.midPanelHeight;           
           set(get(t(i),'Children'), 'linewidth', options.dendrlinewidth);
        elseif strcmp(get(t(i), 'tag'), 'HeatMapAxes')
           currPos(1) = clustergram_props.leftPanelWidth+options.outer_padding+options.inner_padding;
           currPos(2) = clustergram_props.lowPanelHeight+options.outer_padding+options.inner_padding;
           currPos(3) = clustergram_props.midPanelWidth;
           currPos(4) = clustergram_props.midPanelHeight;
        elseif strcmp(get(t(i), 'tag'), 'DendroColAxes')
           currPos(1) = clustergram_props.leftPanelWidth+options.outer_padding+options.inner_padding;
           currPos(2) = clustergram_props.lowPanelHeight+clustergram_props.midPanelHeight+options.outer_padding+options.inner_padding;
           currPos(3) = clustergram_props.midPanelWidth;
           set(get(t(i),'Children'), 'linewidth', options.dendrlinewidth);   
        elseif strcmp(get(t(i), 'tag'), 'HeatMapTitleAxes')
           %do nothing, its position does not change
        end      
        set(t(i), 'Position',currPos);
    end
    
    %set font after resizing the heatmap, otherwise, it won't take effect
    %attempting to fix the font size so it doesn't change when figure is
    %resized - for some reason it doesn't work for the heatmap labels.
    set(heatmapAx, 'defaultAxesFontsize', options.textfont);
    set(heatmapAx, 'FontSize', options.textfont)
    %set background to white
    set(clusterfig(currClustergramIdx),'color','w');
    
   %% add the image labels, if exist
    
    if numberOfImgLabels > 0 %if there are labels to plot
        
        %set up the axis         
        img_lbl_pos = [clustergram_props.leftPanelWidth+options.outer_padding+options.inner_padding, options.outer_padding, ...
            clustergram_props.midPanelWidth, clustergram_props.lowPanelHeight];         
        legend_pos = [clustergram_props.leftPanelWidth+clustergram_props.midPanelWidth+options.outer_padding+2*options.inner_padding,...
            options.outer_padding, clustergram_props.rightPanelWidth, clustergram_props.lowPanelHeight]; 
        descr_pos = [options.outer_padding, options.outer_padding, clustergram_props.leftPanelWidth, clustergram_props.lowPanelHeight];
        img_lbl_ax = axes(clusterfig(currClustergramIdx),'Position',img_lbl_pos, 'Units','normalized');
        legend_ax = axes(clusterfig(currClustergramIdx),'Position',legend_pos, 'Units','normalized');
        descr_ax = axes(clusterfig(currClustergramIdx),'Position',descr_pos, 'Units','normalized');
        set(img_lbl_ax, 'YDir', 'normal');
        hold(img_lbl_ax,'on');set(img_lbl_ax,'visible','off');
        hold(legend_ax,'on');set(legend_ax,'visible','off');
        hold(descr_ax,'on');set(descr_ax,'visible','off');
        
        %order the labels in the same order as the clustering
        %get the tickLabels(trim edging white spaces)
        all_col_labels = strtrim(clust_obj.ColumnLabels);
        if ~isempty(options.columnLabels) %column labels were specified            
            [~,~, order] = intersect(all_col_labels, options.columnLabels, 'stable');
        else  
            order = cell2mat(cellfun(@str2num, all_col_labels, 'UniformOutput', false));
        end
        
        %assign colormap to the image label axis
        [cmap,labels_struct] = addLblVector(labels_struct, order);
        colormap(img_lbl_ax, cmap); 
        
        fn = fieldnames(labels_struct);
        txt_h = clustergram_props.txt_height;
        bar_extent = txt_h*options.maxrowsOfLbls;
        mid = zeros(numberOfImgLabels,1);
        
        %position of the last row in an individual legend group. It is
        %used to set the starting y position for the next legend group        
        curr_row_num = 0;

        %plot legend labels first and compute the size for the images
        for i=1:numberOfImgLabels
            curr_lbl_data = labels_struct.(fn{i});
            
            y_axis_incr = 1/clustergram_props.num_legend_rows;
            x_axis_incr = 1/sum(clustergram_props.maxnumchars_legend_cols(i, :));
            % add legend   
            legends = curr_lbl_data.ordered_lbls;
            leg_col = curr_lbl_data.colorids;
            %remove labels that are marked to be excluded
            if sum(strcmpi(fieldnames(curr_lbl_data), 'excl_from_legend')) == 1
                flag = strcmp(legends, curr_lbl_data.excl_from_legend);
                legends(flag) = [];
                leg_col(flag) = [];
            end
            %distribute the legends in each group, such that they only take
            %options.maxrowsOfLbls rows
            numrows = options.maxrowsOfLbls;
            numcols = ceil(length(legends)/numrows);

            %record the x position of each column, to determine the x
            %position of the next column
            curr_xpos = 0;
            
            for k=1:numcols
                %current indices of the legends
                curr_start = 1+(k-1)*numrows;
                curr_end = min(length(legends), curr_start+numrows-1);
                curr_legends = legends(curr_start:curr_end);
                curr_leg_col = leg_col(curr_start:curr_end); %indices to the color               
                for j=1:min(numrows, length(legends)-curr_start+1)
                    scatter (legend_ax, curr_xpos, 1-(curr_row_num+j-1)*y_axis_incr, 20, cmap(curr_leg_col(j), :), 'filled', 'Marker', 'o')
                    text(legend_ax, curr_xpos+txt_h, 1-(curr_row_num+j-1)*y_axis_incr, curr_legends(j), 'fontsize', options.img_textfont);                                         
                    if k==1                        
                        %record the bumber if rows based on the first column
                        numrowsInCurrCategory = j;
                    end                    
                end
                %x position of the next column is based on the longest
                %legend of the current column
                %curr_xpos = max(x_pos)+2*txt_h;
                curr_xpos = curr_xpos + clustergram_props.maxnumchars_legend_cols(i,k)*x_axis_incr;
            end            
            %compute the center of the current label category/group to
            %display the image and the description in the center
            mid(i) = 1 - ((2*curr_row_num+numrowsInCurrCategory-1)*y_axis_incr)/2;
            %advance the row number 
            curr_row_num = curr_row_num+numrowsInCurrCategory+.5; %add .5 for the blank space between label categories
            bar_extent = min(bar_extent, y_axis_incr/4); %imagesc adds 2 more points to the right and to the left of the specified points;
            %plot the description label
            text(descr_ax, 0, mid(i), curr_lbl_data.description, 'fontsize', options.img_textfont);            
        end
        %plot this one separately, because first need to compute the extent
        for i=1:numberOfImgLabels
            curr_lbl_data = labels_struct.(fn{i});
            %even though the extent is the same for all images, their
            %height is different on the plot - don't know how to solve
            %this.
            imagesc(img_lbl_ax, .5, [mid(i)-bar_extent mid(i)+bar_extent], curr_lbl_data.colorid_vector');
        end
        
        %cleanup the look
        %hide xlabels on the heatmap
        set(heatmapAx, 'xtick',[]);
         lims = [0 1];
      ylim(legend_ax, lims);
        ylim(img_lbl_ax, lims); ylim(descr_ax, lims);
        xlim(legend_ax, [0 1]);
        xlim(img_lbl_ax, [0 clustergram_props.num_txt_lbls]);
        hold(legend_ax,'off'); hold(img_lbl_ax,'off'); hold(descr_ax,'off');
        %axis padded
    end %end if there are labels to plot
    
    %% Add the color bar to the clustergram, 
    % must add at the end, so that MATLAB automatically positions it in the right place.
    cbButton = findall(clusterfig(currClustergramIdx),'tag','HMInsertColorbar');
    % Get callback (ClickedCallback) for the button:
    ccb = get(cbButton,'ClickedCallback');
    % Change the button state to 'on' (clicked down):
    set(cbButton,'State','on');
    % Run the callback to create the colorbar:
    ccb{1}(cbButton,[],ccb{2});
    % %modify the font of the colorbar
    cb  = findobj(clusterfig(currClustergramIdx),'Tag','HeatMapColorbar');
    set(cb,'FontSize', options.textfont);
    %shift to right by colorbar_offset to fit in the figure
    pos = get(cb, 'Position');
    pos(1) = pos(1)+ options.outer_padding;
    set(cb, 'Position', pos);

end %main function
 
 
function [cmap, data_struct] = addLblVector(data_struct, order)
%Create color map for all the colors that were specified for the color
%labels. The colormap will be assigned to an axis that holds all color
%label strips. To make sure that for each color label a correct color is
%selected from the colormap, indices to the rows in the color map are
%assigned for each color strip in a form of vector - an index for each
%unique label.
% 
    fn = fieldnames(data_struct);
    cmap = [];   
    for i=1:length(fn)
        curr_lbl_data = data_struct.(fn{i});
        %sort by the order of the clustering
        curr_lbl_data.labels = curr_lbl_data.labels(order);
        %combine all unique colors into one colormap        
        cmap = unique([cmap; curr_lbl_data.colors], 'stable', 'rows');
        colorid_vector = zeros(length(curr_lbl_data.labels),1);
        color_ids = zeros(length(curr_lbl_data.ordered_lbls),1);
        for j=1:length(curr_lbl_data.ordered_lbls)
            %find index in the color map and assign it to each label
            currcol = curr_lbl_data.colors(j, :);
            [~, currindx] = ismember(currcol, cmap, 'rows');
            colorid_vector(strcmpi(curr_lbl_data.labels, curr_lbl_data.ordered_lbls(j))) = currindx;
            color_ids(j) = currindx;
        end
        data_struct.(fn{i}).colorid_vector = colorid_vector;
        data_struct.(fn{i}).colorids = color_ids;
    end

end
 
function properties = calcTextSize(ax, data_struct, fntSize, maxRowsPerLegCol)
%calculate the length and height needed for the longest legend label and for
%the longest description label. This allows to adjust the axis
%accordingly
    properties = struct();
    properties.txt_height = 0;
    properties.leg_txtwidth = 0;
    properties.descr_txtwidth = 0;
    properties.num_txt_lbls = 0;    
    properties.num_legend_rows = 0;

    fn = fieldnames(data_struct);
    if ~isempty(fn)
        %pul all unique labels into one cell array
        all_txt_labels = {};
        longest_leg_str = {};
        longest_descr_str = {};
        cnt_excluded = 0;

        %for each column of the labels, store the length of the longest
        %string. This will be used to determine the x position for plotting
        properties.maxnumchars_legend_cols = zeros(length(fn), 1);

        for i=1:length(fn)     
            
            %find the longest legend or if multiple columns - sum of longest legends
            curr_leg_labels = data_struct.(fn{i}).ordered_lbls';
            %find nearest size array divisible by the maximum number of
            %rows per legend column
            numCols = ceil(length(curr_leg_labels) / maxRowsPerLegCol);
            b = maxRowsPerLegCol * numCols;
            %create array that is the number of columns times the number of
            %rows per column to store all the labels.
            temp = cell(b,1);
            temp(:) = {' '};
            temp(1:length(curr_leg_labels)) = curr_leg_labels; 
            %reshape the array by the number of rows and columns - it will
            %have the same size as the plotted labels on the plot
            temp = reshape(temp, maxRowsPerLegCol,[]); 
            new_leg_labels = cell(maxRowsPerLegCol,1);  
            %concatinate the labels in each row, to determine the row with
            %the longest labels combined across all the columns. Place three 
            % spaced dashes ( --- ) between each column to represent the circular marker
            for j=1:maxRowsPerLegCol
                new_leg_labels{j} = strjoin(temp(j,:), ' ------ ');
            end
            %find the longest string (among all the legend groups)
            val=cellfun(@(x) numel(x),new_leg_labels);            
            longest_curr_str=new_leg_labels(val==max(val));
            if length(longest_curr_str{1}) > length(longest_leg_str)
                %if there are multiple longest strings, take the first one.
                longest_leg_str = cell2mat(longest_curr_str(1));
            end
            properties.num_legend_rows = properties.num_legend_rows + ...
                min(maxRowsPerLegCol, length(data_struct.(fn{i}).ordered_lbls)) +.5;%extra .5 as a blank between lebel categories
            %expand the "max label length array" for new rows and columns
            %as needed
            if isempty(properties.maxnumchars_legend_cols)
                extra_cols2add = numCols;
            else %don't add if the size is larger than current number of columns
                extra_cols2add = max(0, numCols-length(properties.maxnumchars_legend_cols(1,:)));
            end            
            properties.maxnumchars_legend_cols = padarray(properties.maxnumchars_legend_cols, [0 extra_cols2add], 'post');
            lbl_lengths = cellfun(@length,temp);
            properties.maxnumchars_legend_cols(i, :) = max(lbl_lengths,[], 1)+2; %plus 2 for the circular marker

            %find the longest description label
            % adjust if there is a newline added to the description - take
            %the longest piece.
            descr = cell2mat(data_struct.(fn{i}).description);
            ind = strfind(descr, newline);
            if ~isempty(ind)
                str1 = descr(1:ind(1));
                str2 = descr(ind(1):end);
                if length(str1) >= length(str2)
                    curr_str_descr = str1;
                else
                    curr_str_descr = str2;
                end
            else
               curr_str_descr= data_struct.(fn{i}).description;
            end
            %don't count itilicized or bold modifiers
            curr_str_descr = strrep(curr_str_descr, '{\it', '');
            curr_str_descr = strrep(curr_str_descr, '{\bf', '');
            if isempty(longest_descr_str) || length(longest_descr_str{:}) < length(curr_str_descr{:})
                longest_descr_str = curr_str_descr;
            end
            %count how many legends are excluded
            if sum(strcmpi(fieldnames(data_struct.(fn{i})), 'excl_from_legend')) == 1
                cnt_excluded = cnt_excluded+length(data_struct.(fn{i}).excl_from_legend);
            end
        end
        properties.num_legend_rows = properties.num_legend_rows-1; %remove the last white padding
        properties.num_txt_lbls = length(data_struct.(fn{i}).labels); %number of columns
        %find the extent of the longest legend label
        t = text(ax, 0.5,0.5,longest_leg_str, 'fontsize', fntSize, 'Units','normalized');
        e = get(t, 'Extent');
        properties.txt_height = e(4);
        properties.leg_txtwidth = e(3);
        delete(t);        
        
        %measure the extent of the longest description label 
        t = text(ax, 0.5,0.5,longest_descr_str, 'fontsize', fntSize, 'Units','normalized');
        e = get(t, 'Extent');
        properties.descr_txtwidth = e(3);
        delete(t);
    end
end
 
function data_struct = adjustTextLabels(data_struct)
%adjusts lengths of the labels and description to the maximum length
% If labels and ordered_lbl fields are numeric, it
%converts them to cell array of characters - to be compatible with the code
    fn = fieldnames(data_struct);
    for i=1:length(fn)
        %if ordered_lbls is numeric vector, convert to string
        data_struct.(fn{i}).ordered_lbls = convertIfNeeded(data_struct.(fn{i}).ordered_lbls);
        %if labels is numeric vector, convert to string
        data_struct.(fn{i}).labels = convertIfNeeded(data_struct.(fn{i}).labels);
        % check the max length of the labels, if longer than 15chars- truncate
        x = 1:length(data_struct.(fn{i}).ordered_lbls);
        x=x(cellfun(@(x) numel(x),data_struct.(fn{i}).ordered_lbls)>15);
        for j=1:length(x)%for all labels longer than 15 chr - truncate
            currstr = data_struct.(fn{i}).ordered_lbls{x(j)};
            flag = strcmpi(data_struct.(fn{i}).labels, currstr);
            data_struct.(fn{i}).ordered_lbls{x(j)}= currstr(1:15);
            data_struct.(fn{i}).labels(flag) = {currstr(1:15)};
            disp(['Note: label ' currstr ' is too long, truncating to 15 characters']);
        end
        % check the max length of the description, if longer than 30 - truncate,
        %add new line at a space closest to 15 chars
        x = 1:length(data_struct.(fn{i}).description);
        x=x(cellfun(@(x) numel(x),data_struct.(fn{i}).description)>15);
        for j=1:length(x)
            currstr = data_struct.(fn{i}).description{x(j)};  
            %don't count itilicized or bold symbols
            tmp = strrep(currstr, '{\it', '');
            %find first space after 15th character and replace it with the new line
            ind = strfind(tmp(15:end), ' ');
            if ~isempty(ind)
                ind = ind(1)+14;
                last = min(ind*2, length(currstr));
                currstr = [currstr(1:ind-1) newline() currstr(ind+1:last)];
            end            
            data_struct.(fn{i}).description{x(j)}= currstr;
        end
    end
end
function mustBeValidStruct(data_struct)
% Custom validation function
%check that the input struct has all the required fields with matching
%lengths and values as required by the function (see modifyClustergram
%function description). 
 
    % Check for MATLAB version, need (2020a) or higher
    if verLessThan('matlab','9.8.0')
        error('modifyClustergram requires MATLAB 2020a or higher');
    end
    %check the input is a struct
    if ~isstruct(data_struct)
        error('The input must be a struct');
    end
    %check the input struct has all the required fields
    fn = fieldnames(data_struct);
    for i=1:length(fn)
        curr_label = data_struct.(fn{i});
        if sum(strcmpi(fieldnames(curr_label), 'labels')) ~= 1 || ...
                sum(strcmpi(fieldnames(curr_label), 'colors')) ~= 1 || ...
                sum(strcmpi(fieldnames(curr_label), 'ordered_lbls')) ~= 1 || ...
                sum(strcmpi(fieldnames(curr_label), 'description')) ~= 1
            error(['The input must be a struct with 4 fields' ...
                '(labels, colors, ordered_lbls, description) '...
                'for each layer of color labels, label# ' num2str(i)]);
        end
        %check the colors and ordered_lbls have the same
        %length and it is equal to the number of unique labels.
        if size(curr_label.colors,1)~=length(curr_label.ordered_lbls) || ...
                length(curr_label.description)~=1 || ...
                size(curr_label.colors,1)~=length(unique(curr_label.labels))
            error(['Incorrect length of the input fields, label# ' num2str(i)]);
        end
        %check that unique labels are the same as the ordered_lbls
        %if ordered_lbls is numeric vector, convert to string
        curr_label.ordered_lbls = convertIfNeeded(curr_label.ordered_lbls);
        %if labels is numeric vector, convert to string
        curr_label.labels = convertIfNeeded(curr_label.labels);
        [~,indA] = intersect(curr_label.ordered_lbls, unique(curr_label.labels));
        if length(indA) ~= length(curr_label.ordered_lbls)
            error(['Mismatch between labels and the ordered_lbls. ' ...
                'The labels field consists of labels for each sample, ' ...
                'the ordered_lbls consists of unique label categories, ordered '...
                'in the order to be displayed in the legend, label# ' num2str(i)]);
        end
        %check that there are at least 2 unique lebels in each 
        if length(unique(curr_label.labels)) < 2
            error(['Each label field must have at least 2 different labels. ' ...
                'Check label# ' num2str(i)]);
        end
        %check if colors is a numeric matrix Nx3
        if ~isnumeric(curr_label.colors) || size(curr_label.colors, 2) ~= 3
            error(['The color vector must be a numeric matrix nx3,' ... 
                ' where n is the number of categories in a label, label# ' num2str(i)]);
        end
        %check that description is a cell array.
        if ~iscell(curr_label.description)
            error('The discription must be a cell array.');
        end
    end
end
 
function mustBeClustergram(clust_obj)
%check the input is a clustergram
    if ~isa(clust_obj, 'clustergram')
        error(['The input must be a clustergram, instead it is a ' class(clust_obj)]);
    end
end
 
function mustBeValidLabels(columnLabels, clust_obj)
%check that the columnLabels are the same as in the clustergram
    if isempty(columnLabels)
        %when Column (or Row) labels are not passed to the clustergram function,
        %it generates numeric labels (1,2,...n)
        order = cell2mat(cellfun(@str2num, clust_obj.ColumnLabels, 'UniformOutput', false));
        %if labels are not numeric, the order is an empty string, that means
        %the ColumnLabels were passed to the clustergram, so options.columnLabels can't be empty 
        if isempty(order)
            error(['User must provide optional parameter for same columnLabels. '...
                'These must be the same as the ones passed to the clustergram function.']);
        end
    else
        columnLabels = convertIfNeeded(columnLabels);
        if ~isequal(sort(columnLabels), sort(strtrim(clust_obj.ColumnLabels)))
            error('The columnLabels in options do not match the columnLabels in the clustergram');
        end
    end
end

function vect_out = convertIfNeeded(vect_in)
%converts a numeric vector to a cell array of strings/chars
    vect_out = vect_in;
    if isnumeric(vect_out)
        if iscolumn(vect_out) %must be row in order to be converted
            vect_out = vect_out';
        end
        vect_out = strsplit(num2str(vect_out));
    end
end
        