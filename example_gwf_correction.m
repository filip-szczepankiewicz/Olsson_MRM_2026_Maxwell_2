clear 

[gwf, rf, dt] = amc_gwf_example;
[gwf, rf, dt] = fwf.gwf.toInterpolated(gwf, rf, dt, 2000);


g = 300; % mT/m

gwf = gwf/max(vecnorm(gwf, 2, 2))*g/1000;

B0 = 3;
m_thr = B0*1000;
n_triag = 7;
n_iter = 24;
radius = 0.2;
st = 5e-3;
a = 0.5;
f = 0;

% [gwfc, rf, dt] = fwf_gwf_force_maxwellIndex_v5(gwf, rf, dt, n_triag, m_thr, n_iter);

[gwfc, rf, dt] = fwf.gwf.force.maxwell(gwf, rf, dt, n_triag, m_thr, n_iter);


gwfc = fwf.gwf.force.shape(gwfc, rf, dt, 'ste');
gwfc = gwfc/max(vecnorm(gwfc, 2, 2))*g/1000;


u = fix_getSurface('sphere250');

co = 1 - amc_gwf_to_bias_fast(gwf, rf, dt, u*radius, st, B0, a, f);
cc = 1 - amc_gwf_to_bias_fast(gwfc, rf, dt, u*radius, st, B0, a, f);

figure(1)
clf

subplot(1,2,1);
amc_plot_bias_surface(co*100, u*radius);

subplot(1,2,2);
amc_plot_bias_surface(cc*100, u*radius);




