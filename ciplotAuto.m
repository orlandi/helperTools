function plot_handle = ciplotAuto(x, y, colour, alpha, mode)
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
N = sum(~isnan(y),2);
fac = 1; % 1.96
if(mode == 2)
  lower = nanmedian(y, 2)-fac*nanstd(y, [], 2)./sqrt(N);
  upper = nanmedian(y, 2)+fac*nanstd(y, [], 2)./sqrt(N);
else
  lower = nanmean(y, 2)-fac*nanstd(y, [], 2)./sqrt(N);
  upper = nanmean(y, 2)+fac*nanstd(y, [], 2)./sqrt(N);
end
lower(N == 0) = [];
upper(N == 0) = [];
x(N == 0) = [];
plot_handle = ciplot(lower,upper,x,colour,alpha);
