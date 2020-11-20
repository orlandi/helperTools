function success = tmpLoad(tmpFolder, file, varargin)
  success = false;
  [fpa, fpb, fpc] = fileparts(file);
  if(isempty(fpb))
    varargout = {};
    fprintf('File %s not found, file\n', file);
    return;
  end
  tmpFile = fullfile(tmpFolder, [fpb fpc]);
  if(~exist(tmpFile, 'file'))
    fprintf('File %s not found in the tmp folder. Copying ...\n', file);
    [s, m mID] = copyfile(file, tmpFile);
  else
    srcInfo = dir(file);
    tmpInfo = dir(tmpFile);
    if(srcInfo.datenum ~= tmpInfo.datenum || srcInfo.bytes ~= tmpInfo.bytes)
      fprintf('Src and tmp files might have changed. Updating ...\n');
      [s, m mID] = copyfile(file, tmpFile);
    else
      fprintf('Src and tmp files match. Loading from tmp\n');
    end
  end
  fprintf('Loading %s ...\n', tmpFile);
  if(isempty(varargin))
    data = load(tmpFile);
  else
    data = load(tmpFile, varargin{:});
  end
  fNames = fieldnames(data);
  if(isempty(fNames))
    assignin('base', 'data', data)
     fprintf('data succesfully loaded\n');
  else
    for it = 1:length(fNames)
      assignin('caller', fNames{it}, data.(fNames{it}))
    end
    fprintf('%s ', fNames{:})
    fprintf('succesfully loaded\n');
  end
  
  success = true;
end