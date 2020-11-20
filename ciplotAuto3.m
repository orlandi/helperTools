function plot_handle = ciplotAuto3(x, y, colour, alpha, mode, normFlag, fac)
if nargin<7 || isempty(fac)
  fac = 1;
end
if nargin<6 || isempty(normFlag)
  normFlag = true;
end
if nargin<5 || isempty(mode)
  mode = 1;
end
if nargin<4 || isempty(alpha)
  alpha=0.5;
end
if nargin<3 || isempty(colour)
  colour='b';
end
%lower = nanmean(y, 2)-1.96*nanstd(y, [], 2)/sqrt(size(y, 2));
N = sum(~isnan(y(:,:,1)),2);
if(~normFlag)
  N = 1; % So no normalization
end
if(mode == 2)
  avgFun = @nanmedian;
else
  avgFun = @nanmean;
end

if(ndims(y) == 3)
  lower = avgFun(avgFun(y, 3),2)-fac*squeeze(avgFun(nanstd(y, [], 2),3))./sqrt(N);
  upper = avgFun(avgFun(y, 3),2)+fac*squeeze(avgFun(nanstd(y, [], 2),3))./sqrt(N);

  lower(N == 0) = [];
  upper(N == 0) = [];
  x(N == 0) = [];

else
  lower = avgFun(y, 2)-fac*nanstd(y, [], 2)./sqrt(N);
  upper = avgFun(y, 2)+fac*nanstd(y, [], 2)./sqrt(N);

  lower(N == 0) = [];
  upper(N == 0) = [];
  x(N == 0) = [];
end
plot_handle = ciplot(lower,upper,x,colour,alpha);
hold on;
if(ischar(colour))
  plot_handle = [plot_handle; plot(x, (upper+lower)/2, colour)];
else
  plot_handle = [plot_handle; plot(x, (upper+lower)/2, 'Color', colour)];
end
