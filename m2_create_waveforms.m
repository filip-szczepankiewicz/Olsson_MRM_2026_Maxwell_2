clear
clc;

oname = 'data_now_new_waveforms';
gl = [20 40 80 120 200 300 600];
bl = [0.03 0.06 0.1 0.2 0.5 1.5 3 7];
mi = 1000;

for i = 1:numel(gl)

    switch gl(i)
        case 20
            d1 = 83;
        case 40
            d1 = 54;
        case 80
            d1 = 36;
        case 120
            d1 = 29;
        case 200
            d1 = 22;
        case 300
            d1 = 18;
        case 600
            d1 = 13;
        otherwise
            error()
    end

    d2 = d1 - 6;
    gamp = gl(i);

    p = optimizationProblem();
    p.durationFirstPartRequested = d1;
    p.durationSecondPartRequested = d2;

    p.durationZeroGradientRequested = 8;

    p.gMax = gamp;
    p.sMax = gamp;

    p = optimizationProblem(p);
    p.N = sum([d1; d2; p.durationZeroGradientRequested']);
    p = optimizationProblem(p);

    for j = 1:numel(bl)
        p.MaxwellIndex = mi.*bl(j);


            [R{i,j}, P{i,j}] = NOW_RUN(p);

            [gwf, rf, dt] = fwf.util.nowUnpack(R{i});

        [i j]
    end
end


% save(oname)