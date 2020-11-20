function offsetAxes(axx, varargin)
% thanks to Pierre Morel, undocumented Matlab
% and https://stackoverflow.com/questions/38255048/separating-axes-from-plot-area-in-matlab
%
% by Anne Urai, 2016
% Modified by Javier Orlandi, 2019

if(~exist('axx', 'var'))
  axx = gca;
end
for it1 = 1:length(axx)
  ax = axx(it1);
  set(ax, 'TickDir', 'out');
  box(ax, 'off');
  try
    set(ax.Parent,'Color','w');
  end

  if(nargin > 1)
    factor = varargin{1};
  else
    factor = 20;
  end
  
  % modify the x and y limits to below the data (by a small amount)
  XT = ax.XTick;
  YT = ax.YTick;
  ax.XTickMode = 'manual';
  ax.YTickMode = 'manual';
  if(it1 == 1)
    ax.XLim(1) = ax.XLim(1)-(ax.XLim(2)-ax.XLim(1))/factor;
  end
  ax.YLim(1) = ax.YLim(1)-(ax.YLim(2)-ax.YLim(1))/factor;
  %ax.XLim(1) = ax.XLim(1)-(ax.XTick(2)-ax.XTick(1))/factor;
  %ax.YLim(1) = ax.YLim(1)-(ax.YTick(2)-ax.YTick(1))/factor;
  % this will keep the changes constant even when resizing axes
  if(it1 == 1)
    addlistener(ax, 'MarkedClean', @(obj,event)resetVertexL(ax, factor));
  else
    addlistener(ax, 'MarkedClean', @(obj,event)resetVertexR(ax, factor));
  end
end

end

function resetVertexL(ax, fac)
  factor = 1/fac;
  %ax.XTickMode = 'manual';
  % extract the x axis vertext data
  % X, Y and Z row of the start and end of the individual axle.
  %ax.XRuler.Axle.VertexData
  %ax.XRuler.Axle.VertexData(1,1) = min(get(ax, 'Xtick'));
  
  ax.XRuler.Axle.VertexData(1,1) = (ax.XLim(1)+ax.XLim(2)*factor)/(1+factor);
  
  % repeat for Y (set 2nd row)
  %ax.YRuler.Axle.VertexData(2,1) = min(get(ax, 'Ytick'));
  ax.YRuler.Axle.VertexData(2,1) = (ax.YLim(1)+ax.YLim(2)*factor)/(1+factor);
 
  %ax.XRuler.Axle.VertexData
end
function resetVertexR(ax, fac)
  factor = 1/fac;

  ax.XRuler.Axle.VertexData(1,2) = (ax.XLim(2)-ax.XLim(1)*factor)/(1+factor);
  ax.YRuler.Axle.VertexData(2,1) = (ax.YLim(1)+ax.YLim(2)*factor)/(1+factor);

end
