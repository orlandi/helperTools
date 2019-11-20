function export_fig_passthrough(fileName, varargin)
if(nargin < 2)
  h = gcf;
else
  h = varargin{1};
end
if(nargin < 3)
  renderer = 'painters';
else
  renderer = varargin{2};
end
try
  export_fig(fileName, h, renderer);
  fp = dir(fileName);
  fprintf('%s succesfully generated in:\n%s\n', fp.name, fp.folder);
catch ME
  cprintf([0.9 0.3 0], '<strong>Warning on export_fig</strong>\n');
  msgText = getReport(ME, 'extended', 'hyperlinks', 'on' );
  cprintf([0.9 0.3 0], '%s\n', msgText)
end