function checkLabel(var,sampleIDs,defaultVal)
% This function checks where the defaultVal is found in var, and which
% samples it corresponds to. 
arguments
    var (1,:) cell {mustBeNonempty}
    sampleIDs (1,:) {mustBeEqualSize(var,sampleIDs)}
    defaultVal (1,:) {mustBeNonempty} = 'ND'
end
    out = inputname(1);
    if isempty(out)
        out = 'entered';
    end
    ind = strcmp(var,defaultVal);
    if any(ind)
        C = [sampleIDs(ind);num2cell(find(ind))];
        fprintf ('The variable %1$s has the value %2$s assigned to:\n',out,defaultVal)
        fprintf('Sample(Index in %s)\n',out)
        fprintf('%s\t(%d)\n',C{:})
    else
        fprintf ('The variable %1$s does not have the value %2$s assigned anywhere.\n',out,defaultVal)
    end
end

function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'Inputs must have equal size.';
        throwAsCaller(MException(eid,msg))
    end
end
