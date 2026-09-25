function s = amc_gwf_to_bias_fast(gwf, rf, dt, r, st, B0, a, f, M)
% function s = amc_gwf_to_bias_fast(gwf, rf, dt, r, st, B0, a, f)

if nargin < 9
    M = ones(size(r));
end

s = zeros(size(r,1),1);

for i = 1:size(r,1)

    if ~M(i)
        continue
    end

    k_mean = amc_gwf_to_kEnd(gwf, rf, dt, r(i,:), B0, a, f);
    s(i)      = abs(mySinc(st/2*k_mean(3)/pi));
end
end

function y = mySinc(x)
y = ones(size(x));
idx = (x ~= 0);
y(idx) = sin(pi*x(idx))./(pi*x(idx));
end