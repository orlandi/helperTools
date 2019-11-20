function [sigGroups p rm] = computeMixedAnova(A, Xpositions, logFile, varargin)
  if(nargin < 4)
    debug = false;
  else
    debug = varargin{1};
  end
  if(nargin < 5)
    multComparisonTest = 'dunn-sidak';
  else
    multComparisonTest = varargin{2};
  end
  
  Xpositions = Xpositions([1 3 2 4]);
  sigGroups = {};
  p = [];
  ffprintf(logFile, '\n Storing table data used for mixed anova\n');
  ffprintf(logFile, 'WT pre | R6 pre | WT post R6 post\n');
  for it = 1:size(A, 1)
    ffprintf(logFile, '%.4f %.4f %.4f %.4f\n', A(it, 1:4));
  end
  t = table([repmat({'WT'}, [size(A, 1), 1]);repmat({'R6'}, [size(A, 1), 1])], [A(:,1);A(:,2)],[A(:,3);A(:,4)], ...
  'VariableNames',{'Genotype', 'basal', 'BIC'});
  Meas = table({'basal'; 'BIC'},'VariableNames',{'Treatment'});

  
  %rm = fitrm(t,'basal,BIC~Genotype','WithinDesign',Meas);
  rm = fitrm(t,'basal,BIC~Genotype','WithinDesign',Meas);

  ranovatbl = ranova(rm);
%   A(isnan(A(:,1)), [1 3]) = NaN;
%   A(isnan(A(:,2)), [2 4]) = NaN;
%   A(isnan(A(:,3)), [1 3]) = NaN;
%   A(isnan(A(:,4)), [2 4]) = NaN;
  WT = A(:, [1 3]);
  R6 = A(:, [2 4]);
  WT(isnan(sum(WT,2)), :) = [];
  R6(isnan(sum(R6,2)), :) = [];

  [sp, stable] = anova_rm({R6 WT}, 'off');
  ffprintf(logFile, evalc('disp(stable)'));
  pval = table2array(ranovatbl(2, 5));
  if(debug)
    ffprintf(logFile, '\n===================\n');
    ffprintf(logFile, 'Mixed ANOVA results:\n');
    ffprintf(logFile, '-------------------\n');
    ffprintf(logFile, 'Interaction p: %.4g\n', pval);
    if pval<=1E-3
      stars='(***)'; 
    elseif pval<=1E-2
      stars='(**)';
    elseif pval<=0.05
      stars='(*)';
    else
     stars = '';
    end
    ffprintf(logFile, ' %s\n', stars);
    ffprintf(logFile, '-------------------\n');
  end
  sigGroups{end+1} = Xpositions([1 4]);
  p = [p; -pval];
  
  
  
  
  ml2 = multcompare(rm,'Genotype', 'ComparisonType', multComparisonTest);
  ml2 = ml2(1:2:end,:);
  ml2 = table2struct(ml2(:, [1 2 5]));
  for it = 1:size(ml2, 1)
    if(debug)
      ffprintf(logFile, '(%s vs %s) - p: %.4g\n', ml2(it).Genotype_1, ml2(it).Genotype_2, ml2(it).pValue);
      if ml2(it).pValue<=1E-3
        stars='(***)'; 
      elseif ml2(it).pValue<=1E-2
        stars='(**)';
      elseif ml2(it).pValue<=0.05
        stars='(*)';
      else
       stars = '';
      end
      ffprintf(logFile, ' %s\n', stars);
    end
    
    %sigGroups{end+1} = Xpositions([2 3])+[0.45, -0.45];
    sigGroups{end+1} = Xpositions([2 3]);
    p = [p; -ml2(it).pValue];
  end
  if(debug)
    ffprintf(logFile, '-------------------\n');
  end


  ml2 = multcompare(rm,'Treatment', 'ComparisonType', multComparisonTest);
  ml2 = ml2(1:2:end,:);
  ml2 = table2struct(ml2(:, [1 2 5]));
  for it = 1:size(ml2, 1)
    if(debug)
      ffprintf(logFile, '(%s vs %s) - p: %.4g\n', ml2(it).Treatment_1, ml2(it).Treatment_2, ml2(it).pValue);
      if ml2(it).pValue<=1E-3
        stars='(***)'; 
      elseif ml2(it).pValue<=1E-2
        stars='(**)';
      elseif ml2(it).pValue<=0.05
        stars='(*)';
      else
       stars = '';
      end
      ffprintf(logFile, ' %s\n', stars);
    end
    sigGroups{end+1} = Xpositions([1 4])+[0.5, -0.5];
    p = [p; -ml2(it).pValue];
  end
  if(debug)
    ffprintf(logFile, '-------------------\n');
  end

  ml2 = multcompare(rm,'Genotype','By','Treatment', 'ComparisonType', multComparisonTest);
  ml2 = ml2(1:2:end,:);
  ml2 = table2struct(ml2(:, [1 2 3 6]));
  for it = 1:size(ml2, 1)
    if(debug)
      ffprintf(logFile, '%s: (%s vs %s) - p: %.4g\n', ml2(it).Treatment, ml2(it).Genotype_1, ml2(it).Genotype_2, ml2(it).pValue);
      if ml2(it).pValue<=1E-3
        stars='(***)'; 
      elseif ml2(it).pValue<=1E-2
        stars='(**)';
      elseif ml2(it).pValue<=0.05
        stars='(*)';
      else
       stars = '';
      end
      ffprintf(logFile, ' %s\n', stars);
    end
    if(it == 1)
      sigGroups{end+1} =  Xpositions([2 4]);
    else
      sigGroups{end+1} =  Xpositions([1 3]);
    end
    p = [p; ml2(it).pValue];
  end
  if(debug)
    ffprintf(logFile, '-------------------\n');
  end
  
  ml2 = multcompare(rm,'Treatment','By','Genotype', 'ComparisonType', multComparisonTest);
  ml2 = ml2(1:2:end,:);
  ml2 = table2struct(ml2(:, [1 2 3 6]));
  for it = 1:size(ml2, 1)
    if(debug)
      ffprintf(logFile, '%s: (%s vs %s) - p: %.4g\n', ml2(it).Genotype, ml2(it).Treatment_1, ml2(it).Treatment_2, ml2(it).pValue);
      if ml2(it).pValue<=1E-3
        stars='(***)'; 
      elseif ml2(it).pValue<=1E-2
        stars='(**)';
      elseif ml2(it).pValue<=0.05
        stars='(*)';
      else
       stars = '';
      end
      ffprintf(logFile, ' %s\n', stars);
    end
    if(it == 1)
      sigGroups{end+1} =  Xpositions([3 4]);
    else
      sigGroups{end+1} =  Xpositions([1 2]);
    end
    p = [p; ml2(it).pValue];
  end
  
  if(debug)
    ffprintf(logFile, '===================\n');
  end