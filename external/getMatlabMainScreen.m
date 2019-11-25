 function [mon, curMonPos] = getMatlabMainScreen()
 % From https://stackoverflow.com/questions/37705169/determine-matlabs-monitor-in-a-multiple-monitor-configuration
%% Get monitor list:
monitors = get(groot,'MonitorPositions'); % also get(0,'MonitorPositions');
%% Get the position of the main MATLAB screen:
pt = com.mathworks.mlservices.MLEditorServices.getEditorApplication.getActiveEditor.getComponent.getRootPane.getLocationOnScreen;
matlabScreenPos = [pt.x pt.y] + 1; % "+1" is to shift origin for "pixel" units.
%% Find the screen in which matlabScreenPos falls:
mon = 0;
nMons = size(monitors,1);
if nMons == 1
  mon = 1;
else
    marginLimit = 100;
    margin =0;
    while ~mon
        for ind1 = 1:nMons
            mon = mon + ind1*(...
                matlabScreenPos(1) + margin >= monitors(ind1,1) && matlabScreenPos(1) < sum(monitors(ind1,[1 3])) + margin && ...
                matlabScreenPos(2) + margin >= monitors(ind1,2) && matlabScreenPos(2) < sum(monitors(ind1,[2 4])) + margin );
        end
        margin = margin + 1;
        if margin > marginLimit
            break;
        end
    end
end
curMonPos = monitors(mon, :);