function cmap = divergingBlueRedCmap(nCols)
  % DIVERGINGBLUEREDCMAP Generates a diverging colormap from blue to red
  %
  % USAGE:
  %   cmap = divergingBlueRedCmap(nCols);
  %
  % INPUT arguments:
  %   nCols - Number of colors to use
  %
  % OUTPUT arguments:
  %   cmap - class object
  %
  % EXAMPLE:
  %   cmap = divergingBlueRedCmap(16);
  %
  % Copyright (C) 2019, Javier G. Orlandi <javierorlandi@javierorlandi.com>,
  % Benuccilab (http://benuccilab.brain.riken.jp)
  % Based on python colormaps (I think)
  
  baseCmap = [178,24,43
  239,138,98
  253,219,199
  247,247,247
  209,229,240
  103,169,207
  33,102,172]/255;
  cmap = zeros(nCols, 3);
  for it = 1:3
    cmap(:, it) = interp1(linspace(0,1,size(baseCmap,1)), baseCmap(:, it), linspace(0,1,nCols), 'pchip', 'extrap');
  end
  cmap = flip(cmap, 1);
end
