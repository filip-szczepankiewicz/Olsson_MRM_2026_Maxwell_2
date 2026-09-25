function [gout, rf, dt, x] = fwf_gwf_force_maxwellIndex_v5(gwf, rf, dt, n_pt, m_thr, n_iter, f_bnd)
% function [gout, rf, dt, x] = fwf_gwf_force_maxwellIndex_v5(gwf, rf, dt, n_pt, m_thr, n_iter, f_bnd)
%
% Prototype function that corrects small errors in 0th moment (balance) and
% maxwell index.

if nargin < 4
    n_pt = 7;
end

if nargin < 5
    m_thr = 100;
end

if nargin < 6
    n_iter = 32;
end

if nargin < 7
    f_bnd = 0.05;
end

% get approximate gradient scale to calc fair b-vals
g_nrm = max(vecnorm(gwf, 2, 2));

% Create a triangular waveform with n_pt triangles per axis
fvec = amc_create_weight_vectors(n_pt, size(gwf,1));

% Set minimization function and search for a minimum
fun  = @(x)this_cost(x, gwf, rf, dt, fvec);

opt = optimset('fminsearch');
opt.OutputFcn = @this_stopFcn;
opt.MaxFunEvals = 5000;
opt.MaxIter     = 5000;

lb = ones(3, n_pt)*-f_bnd;
ub = ones(3, n_pt)* f_bnd;

% translate to SPMD
parfor i = 1:n_iter
    % Guess is n_pt x 3 zeros
    x0 = lb + rand(3, n_pt) .* (ub-lb);
    x  = fminsearch(fun, x0, opt);

    % Apply optimization and return corrected waveform
    [~, GWF{i}] = fun(x);
    X{i} = x;
end

% Find best solution
for i = 1:n_iter
    tmp = GWF{i};

    % Calc m before fixing waveform to comply with threshold definition
    m(i) = fwf.gwf.toMaxwellInd(gwf, rf, dt)*1e9;

    tmp = fwf.gwf.force.balance_v2(tmp, rf, dt);
    tmp = fwf.gwf.force.shape(tmp, rf, dt, 'ste'); % This is tricky and must be removed
    tmp = tmp/max(vecnorm(tmp, 2, 2))*g_nrm;

    b(i) = fwf.gwf.toBvalue(tmp, rf, dt);
end

% Find the highest b-val that conforms with maxwell threshold
ok_ind = m<=(m_thr*1.01);
[~, min_ind] = min(m);

if sum(ok_ind)
    b_max = max(b(ok_ind));
    ind_final = find(b==b_max);
else
    b_max = max(b(min_ind));
    ind_final = find(b==b_max);
end

gout = GWF{ind_final};
x = X{ind_final};


    function stop = this_stopFcn(~, optimValues, ~)
        stop = optimValues.fval<m_thr;
    end

    function [cost, gwf] = this_cost(f, gwf, rf, dt, fvec)
        gwf  = amc_apply_fvec(gwf, fvec, f);
        gwf  = fwf.gwf.force.balance_v2(gwf, rf, dt);
        cost = fwf.gwf.toMaxwellInd(gwf, rf, dt)*1e9;
    end
end

