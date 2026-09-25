function k = amc_gwf_to_kEnd(gwf, rf, dt, r, B0, alpha, f)
% function k = amc_gwf_to_kEnd(gwf, rf, dt, r, B0, alpha, f)

gwf_a = fwf.gwf.toActual(gwf, rf, dt, r, B0, alpha, f);
k     = fwf.util.gammaFromNuc * (gwf_a'*rf)' * dt;