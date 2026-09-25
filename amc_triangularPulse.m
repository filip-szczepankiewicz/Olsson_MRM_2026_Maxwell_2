function triwf = amc_triangularPulse(inda, indb, x)
% function triwf = amc_triangularPulse(inda, indb, x)

triwf = zeros(size(x));

wid = floor((indb-inda)/2);

int1 = inda:(inda+wid);
int2 = (indb-wid):indb;

triwf(int1) = linspace(0, 1, numel(int1));
triwf(int2) = linspace(1, 0, numel(int2));

