function hFig = createCenteredFigure(w, h)
% Creates a figure with a given width and height and centers it in the current screen. Returns the handle
% Get MATLAB app screen coordinates
if(nargin < 1)
  w = 1280;
end
if(nargin < 2)
  h = 720;
end
[~, curMonPos] = getMatlabMainScreen();
% Because
hFig = figure('color', 'w');

monW = curMonPos(3);
monH = curMonPos(4);
hFig.Position = [curMonPos(1)+monW/2-w/2 curMonPos(2)+monH/2-h/2 w h];