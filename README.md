# Concomitant gradient effects across field strengths and gradient amplitudes: improved estimation of errors and correction of concomitant dephasing and diffusion weighting
 
Viktor Olsson<sup>1</sup>, Felix Mortensen<sup>1</sup>, Emil Ljungberg<sup>1</sup>, Frederik Testud<sup>2</sup>, Ronnie Wirestam<sup>1</sup>, Malwina Molendowska<sup>1</sup> and Filip Szczepankiewicz<sup>1,*</sup>
 
1.	Medical Radiation Physics, Clinical Sciences Lund, Lund University, Lund, Sweden
2.	Siemens Healthineers AB, Malmö, Sweden
 
### Overview
Concomitant (Maxwell) gradients become more harmful at lower field strengths and with stronger gradients. This paper derives a compact but accurate expression for concomitant gradients and simulates the resulting signal bias for asymmetric, Maxwell-compensated diffusion encoding waveforms across field strengths (0.03–7 T) and gradient amplitudes (20–600 mT/m). The bias is split into *concomitant dephasing*, which arises when Maxwell compensation is lost during waveform resampling and can be suppressed by a waveform correction applied at the design stage, and *concomitant diffusion weighting*, which is always present but can be accounted for by using the actual gradient waveform in the analysis.

### Citation
[V. Olsson, F. Mortensen, E. Ljungberg, F. Testud, R. Wirestam, M. Molendowska, F. Szczepankiewicz. Concomitant gradient effects across field strengths and gradient amplitudes: improved estimation of errors and correction of concomitant dephasing and diffusion weighting._ Magnetic Resonance in Medicine 96(3):1178–1191, 2026.](https://doi.org/10.1002/mrm.70422)
 
### Contents

Below are materials related to the publication. Note that the correction algorithm is maintained as part of the [FWF tools]([https://github.com/filip-szczepankiewicz/fwf_sequence_tools](https://github.com/filip-szczepankiewicz/fwf_sequence_tools/blob/master/%2Bfwf/%2Bgwf/%2Bforce/maxwell.m) in the function `fwf.gwf.force.maxwell`.

| File | Description |
|---|---|
| `example_gwf_correction.m` | Start here. Takes an example waveform, scales it to 300 mT/m, applies the Maxwell-index correction at 3 T, and plots the signal bias (%) over a spherical surface (r = 20 cm) before and after correction. |
| `m2_create_waveforms.m` | Generates the asymmetric, Maxwell-compensated NOW waveforms used in the simulations, on a grid of g<sub>max</sub> = 20–600 mT/m and B<sub>0</sub> = 0.03–7 T. |
| `fwf_gwf_force_maxwellIndex_v5.m` | Prototype of the waveform correction. Adds small triangular perturbations to each axis and uses repeated `fminsearch` runs (`parfor`) to restore balance and bring the Maxwell index below a threshold, keeping the solution with the highest b-value. |
| `amc_gwf_to_bias_fast.m` | Signal bias from concomitant dephasing at a set of positions, from the residual k-space offset along the slice direction integrated over the slice thickness. |
| `amc_gwf_to_kEnd.m` | k-space position at the end of encoding, computed from the actual gradient waveform including concomitant fields. |
| `amc_plot_bias_surface.m` | Plots the bias as a coloured surface in phase/frequency/slice coordinates. |
| `amc_gwf_example.m` | Example STE waveform used by the demo. |
| `amc_triangularPulse.m` | Helper that builds the triangular basis functions. |
| `waveforms/NOW_waveforms.mat` | Uncorrected NOW waveforms and optimization problems (`R`, `P`) for the 7 × 8 grid of g<sub>max</sub> × B<sub>0</sub>. |
| `waveforms/corrected_waveforms.mat` | Original (`GO`) and corrected (`GC`) waveforms with their time steps (`DT`) for the same grid. |
 
### Dependencies
The code is written in MATLAB and requires:
- The [NOW toolbox](https://github.com/jsjol/NOW) for numerical optimization of gradient waveforms (only needed for `m2_create_waveforms.m`).
- The [FWF tools](https://github.com/filip-szczepankiewicz/fwf_sequence_tools), used for calculations
- The Parallel Computing Toolbox for `parfor` in the correction prototype. Without it the loop runs serially.

#### Resources related to the FWF sequence can be found at the [FWF sequence GIT repository](https://github.com/filip-szczepankiewicz/fwf_seq_resources)
 
