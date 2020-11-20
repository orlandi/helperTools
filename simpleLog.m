classdef simpleLog
  properties (Access = private)
    timestamp;
  end
  
  methods
    % The actual constructor
    function obj = simpleLog(varargin)
      if(nargin < 1)
        obj.timestamp = true;
      else
        obj.timestamp = varargin{1};
      end
      pause(0.1); % For initialization purposes
    end
    
    function out = info(obj, textMsg)
      if(obj.timestamp)
        tag = [datestr(now, 13) ' '];
      else
        tag = '';
      end
      out = cprintf('*blue', [tag textMsg '\n']);
    end
    
    function out = bold(obj, textMsg)
      if(obj.timestamp)
        tag = [datestr(now, 13) ' '];
      else
        tag = '';
      end
      out = cprintf('*black', [tag textMsg '\n']);
    end
    
    function out = error(obj, textMsg)
      if(obj.timestamp)
        tag = [datestr(now, 13) ' '];
      else
        tag = '';
      end
      out = cprintf('*red', [tag textMsg '\n']);
    end
    
    function out = regular(obj, textMsg)
      if(obj.timestamp)
        tag = [datestr(now, 13) ' '];
      else
        tag = '';
      end
      out = cprintf('black', [tag textMsg '\n']);
    end
    
    function out = warning(obj, textMsg)
      if(obj.timestamp)
        tag = [datestr(now, 13) ' '];
      else
        tag = '';
      end
      out = cprintf([0.9 0.3 0], sprintf('<strong>%s%s</strong>\n', tag, textMsg));
    end
    
  end
end